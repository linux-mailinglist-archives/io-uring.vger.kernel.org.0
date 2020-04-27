Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A653A1BAA6E
	for <lists+io-uring@lfdr.de>; Mon, 27 Apr 2020 18:50:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726204AbgD0Qud (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 27 Apr 2020 12:50:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726189AbgD0Qud (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 27 Apr 2020 12:50:33 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A49EC0610D5
        for <io-uring@vger.kernel.org>; Mon, 27 Apr 2020 09:41:00 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id x2so17326872ilp.13
        for <io-uring@vger.kernel.org>; Mon, 27 Apr 2020 09:41:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=YS84Xe4scrBRb9cR+rSYDXtOJiflazO3NxL3MDlqhBk=;
        b=GAHDj0fvX6BPDZM7biI1r+Yl+6xBXICHjljtSRrKw7aNEXQL9Gpm0l1QM+OvFloX1l
         GBT16Bd3uRHWwMfxUSLUbTHc3GbeYXf7r0+0nsm/99GDUTBQX3Kx4vBoFJOX/zEG9AOO
         gdMUVR98TsQ6zpTT07loM5Dy5LIEePaus/xj4XLy9dY/6zFKTInu04rpqwaLNvypQHgE
         FzAHL9HwdCfuaMaXnq70vFkOGwi5G9H++5j2Kidu5POEGGe6Pf28EnF0+MYhbcZbk0k+
         PeyIU7W2kzFlg0igTnrvICLO3JzMvIzdINPQD9AfhgoDTg3OeX/5qneT5P9gcRMCArRM
         yqcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YS84Xe4scrBRb9cR+rSYDXtOJiflazO3NxL3MDlqhBk=;
        b=BMbl7kHd0+yDQ0ILUX/0VJ8EHrmXudiVZrok9EocrlVjP+5iQP003VZKiyU76TRPWo
         7YshxC3KE/S3avwDRy6uLd+BytaIPX+JnzOb5KkdJuURN4PpQ1WmJuZzSsAmh+Vvo11q
         kSywpb1k7AYdUithZKD1XfVG92SSkcaJQkOwcVaWk+85qBdL41xfiBTs71fnVWACpxZs
         2ajbQdvk7r43xQZX31uqe2ub7dn3BZrhLaWBdC04EmW+/8MEcxCjWy7LuzsmtJ+S0+mt
         pPln2PUTblQPfakEDekEHOZHOKuG61VLgZwDhT5R13tXi4HmDtEfJYRDZJBi53hOZ/mo
         HL7Q==
X-Gm-Message-State: AGi0Pubtz88iULrvZquPTYANiV6TF3eRtb5MFjHupGrIeqqRfFVhFdxW
        c/k/l4RTDLYVKsKNCgA4lhOSbgCSQJfEHA==
X-Google-Smtp-Source: APiQypLAvnnuG/xdvNwLTPGmXc5GhqJWB9dS2+tNlHgwjOonWvRDMtKNjFGnxc4QyPsgbwUGQkmLLQ==
X-Received: by 2002:a92:9e0b:: with SMTP id q11mr20983799ili.277.1588005659482;
        Mon, 27 Apr 2020 09:40:59 -0700 (PDT)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id p5sm5659362ilk.20.2020.04.27.09.40.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Apr 2020 09:40:59 -0700 (PDT)
Subject: Re: io_uring statx fails with AT_EMPTY_PATH
To:     Clay Harris <bugs@claycon.org>, io-uring@vger.kernel.org
References: <20200427152942.zhe6ncun7ijpbffq@ps29521.dreamhostps.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <560ae971-fd9b-4248-cd56-367bde8f903c@kernel.dk>
Date:   Mon, 27 Apr 2020 10:40:57 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200427152942.zhe6ncun7ijpbffq@ps29521.dreamhostps.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/27/20 9:29 AM, Clay Harris wrote:
> Jens Axboe recommended that I post io_uring stuff to this list.
> So, here goes.
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=207453

The below should fix it.


diff --git a/fs/io_uring.c b/fs/io_uring.c
index c687f57fb651..084dfade5cda 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -524,6 +524,7 @@ enum {
 	REQ_F_OVERFLOW_BIT,
 	REQ_F_POLLED_BIT,
 	REQ_F_BUFFER_SELECTED_BIT,
+	REQ_F_NO_FILE_TABLE_BIT,
 
 	/* not a real bit, just to check we're not overflowing the space */
 	__REQ_F_LAST_BIT,
@@ -577,6 +578,8 @@ enum {
 	REQ_F_POLLED		= BIT(REQ_F_POLLED_BIT),
 	/* buffer already selected */
 	REQ_F_BUFFER_SELECTED	= BIT(REQ_F_BUFFER_SELECTED_BIT),
+	/* doesn't need file table for this request */
+	REQ_F_NO_FILE_TABLE	= BIT(REQ_F_NO_FILE_TABLE_BIT),
 };
 
 struct async_poll {
@@ -799,6 +802,7 @@ static const struct io_op_def io_op_defs[] = {
 		.needs_file		= 1,
 		.fd_non_neg		= 1,
 		.needs_fs		= 1,
+		.file_table		= 1,
 	},
 	[IORING_OP_READ] = {
 		.needs_mm		= 1,
@@ -3355,8 +3359,12 @@ static int io_statx(struct io_kiocb *req, bool force_nonblock)
 	struct kstat stat;
 	int ret;
 
-	if (force_nonblock)
+	if (force_nonblock) {
+		/* only need file table for an actual valid fd */
+		if (ctx->dfd == -1 || ctx->dfd == AT_FDCWD)
+			req->flags |= REQ_F_NO_FILE_TABLE;
 		return -EAGAIN;
+	}
 
 	if (vfs_stat_set_lookup_flags(&lookup_flags, ctx->how.flags))
 		return -EINVAL;
@@ -5429,7 +5437,7 @@ static int io_grab_files(struct io_kiocb *req)
 	int ret = -EBADF;
 	struct io_ring_ctx *ctx = req->ctx;
 
-	if (req->work.files)
+	if (req->work.files || (req->flags & REQ_F_NO_FILE_TABLE))
 		return 0;
 	if (!ctx->ring_file)
 		return -EBADF;

-- 
Jens Axboe

