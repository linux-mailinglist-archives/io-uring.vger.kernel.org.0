Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D77047C8D1
	for <lists+io-uring@lfdr.de>; Tue, 21 Dec 2021 22:31:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237032AbhLUVb3 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+io-uring@lfdr.de>); Tue, 21 Dec 2021 16:31:29 -0500
Received: from usmailhost21.kioxia.com ([12.0.68.226]:51222 "EHLO
        SJSMAIL01.us.kioxia.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S237000AbhLUVb3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 21 Dec 2021 16:31:29 -0500
X-Greylist: delayed 901 seconds by postgrey-1.27 at vger.kernel.org; Tue, 21 Dec 2021 16:31:29 EST
Received: from SJSMAIL01.us.kioxia.com (10.90.133.90) by
 SJSMAIL01.us.kioxia.com (10.90.133.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Tue, 21 Dec 2021 13:16:27 -0800
Received: from SJSMAIL01.us.kioxia.com ([fe80::4822:8b9:76de:8b6]) by
 SJSMAIL01.us.kioxia.com ([fe80::4822:8b9:76de:8b6%3]) with mapi id
 15.01.2176.014; Tue, 21 Dec 2021 13:16:27 -0800
From:   Clay Mayers <Clay.Mayers@kioxia.com>
To:     "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
CC:     "axboe@kernel.dk" <axboe@kernel.dk>, "hch@lst.de" <hch@lst.de>,
        "kbusch@kernel.org" <kbusch@kernel.org>,
        "javier@javigon.com" <javier@javigon.com>,
        "anuj20.g@samsung.com" <anuj20.g@samsung.com>,
        "joshiiitr@gmail.com" <joshiiitr@gmail.com>,
        "pankydev8@gmail.com" <pankydev8@gmail.com>
Subject: RE: [RFC 02/13] nvme: wire-up support for async-passthru on
Thread-Topic: [RFC 02/13] nvme: wire-up support for async-passthru on
Thread-Index: Adf2q4Y1jNlE3svCRZSHuwnlq+XxWA==
Date:   Tue, 21 Dec 2021 21:16:27 +0000
Message-ID: <2da62822fd56414d9893b89e160ed05c@kioxia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.90.53.183]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Message-ID: <20211220141734.12206-3-joshi.k@samsung.com>

On 12/20/21 19:47:23 +0530, Kanchan Joshi wrote:
> Introduce handlers for fops->async_cmd(), implementing async passthru on
> char device (including the multipath one).
> The handlers supports NVME_IOCTL_IO64_CMD.
>
I commented on these two issues below in more detail at
https://github.com/joshkan/nvme-uring-pt/issues

> +static void nvme_setup_uring_cmd_data(struct request *rq,
> +		struct io_uring_cmd *ioucmd, void *meta,
> +		void __user *meta_buffer, u32 meta_len, bool write) {
> +	struct nvme_uring_cmd *cmd = nvme_uring_cmd(ioucmd);
> +
> +	/* to free bio on completion, as req->bio will be null at that time */
> +	cmd->bio = rq->bio;
> +	/* meta update is required only for read requests */
> +	if (meta && !write) {
> +		cmd->meta = meta;
> +		cmd->meta_buffer = meta_buffer;
> +		cmd->meta_len = meta_len;
> +	} else {
> +		cmd->meta = NULL;
I believe that not saving meta in cmd->meta will leak it when it's a write. 
But nvme_pt_task_cb also needs to change to copy to user when
cmd->meta_buffer is set instead of cmd->meta.

> +
> +int nvme_ns_chr_async_cmd(struct io_uring_cmd *ioucmd,
> +		enum io_uring_cmd_flags flags)
> +{
> +	struct nvme_ns *ns = container_of(file_inode(ioucmd->file)->i_cdev,
> +			struct nvme_ns, cdev);
> +
> +	return nvme_ns_async_ioctl(ns, ioucmd); }
> +
The uring cmd flags are not being passed to nvme_ns_async_ioctl - what if
IO_URING_F_NONBLOCK Is set?  When it is, I think the nvme_alloc_request()
call in nvme_submit_user_cmd() needs to pass in BLK_MQ_REQ_NOWAIT as
the flags parameter or move to another thread.  Our proto-type does the former
requiring user mode to retry on -EWOULDBLOCK and -EBUSY.

--
Clay Mayers
