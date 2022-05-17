Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9458E529EA5
	for <lists+io-uring@lfdr.de>; Tue, 17 May 2022 12:01:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233269AbiEQKBJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 17 May 2022 06:01:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245633AbiEQKBF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 17 May 2022 06:01:05 -0400
Received: from out30-54.freemail.mail.aliyun.com (out30-54.freemail.mail.aliyun.com [115.124.30.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B245B41F91;
        Tue, 17 May 2022 03:01:01 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R741e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=ziyangzhang@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0VDUBn8Y_1652781657;
Received: from 30.39.94.219(mailfrom:ZiyangZhang@linux.alibaba.com fp:SMTPD_---0VDUBn8Y_1652781657)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 17 May 2022 18:00:58 +0800
Message-ID: <55d724a8-ed7d-ae92-ca6d-3582e13587db@linux.alibaba.com>
Date:   Tue, 17 May 2022 18:00:57 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.1
Subject: Re: [PATCH V2 1/1] ubd: add io_uring based userspace block driver
Content-Language: en-US
To:     Ming Lei <ming.lei@redhat.com>
Cc:     linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        Harris James R <james.r.harris@intel.com>,
        io-uring@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jens Axboe <axboe@kernel.dk>
References: <20220517055358.3164431-1-ming.lei@redhat.com>
 <20220517055358.3164431-2-ming.lei@redhat.com>
From:   Ziyang Zhang <ZiyangZhang@linux.alibaba.com>
In-Reply-To: <20220517055358.3164431-2-ming.lei@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-12.0 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2022/5/17 13:53, Ming Lei wrote:

> +
> +static void ubd_cancel_queue(struct ubd_queue *ubq)
> +{
> +	int i;
> +
> +	for (i = 0; i < ubq->q_depth; i++) {
> +		struct ubd_io *io = &ubq->ios[i];
> +
> +		if (io->flags & UBD_IO_FLAG_ACTIVE) {
> +			io->flags &= ~UBD_IO_FLAG_ACTIVE;
> +			io_uring_cmd_done(io->cmd, UBD_IO_RES_ABORT, 0);
> +		}
> +	}
> +}

Hi Ming,

When ubdsrv sends STOP_DEV and all active IOs in ubd_drv are done(UBD_IO_RES_ABORT),
there may be still some IOs handled by ubdsrv(UBD_IO_FLAG_ACTIVE not set).
When these IOs complete and return to ubd_drv, how to handle them?
I find that UBD_IO_FETCH_REQ are still set,
so will these IOs be issued to ubdsrv again or canceled?
(I see ubd_drv fails IOs when the daemon is dying 
but maybe here the daemon is still alive)



> +
> +/* Cancel all pending commands, must be called after del_gendisk() returns */
> +static void ubd_cancel_dev(struct ubd_device *ub)
> +{
> +	int i;
> +
> +	for (i = 0; i < ub->dev_info.nr_hw_queues; i++)
> +		ubd_cancel_queue(ubd_get_queue(ub, i));
> +}
> +
> +static void ubd_stop_dev(struct ubd_device *ub)
> +{
> +	mutex_lock(&ub->mutex);
> +	if (!disk_live(ub->ub_disk))
> +		goto unlock;
> +
> +	del_gendisk(ub->ub_disk);
> +	ub->dev_info.state = UBD_S_DEV_DEAD;
> +	ub->dev_info.ubdsrv_pid = -1;
> +	ubd_cancel_dev(ub);
> + unlock:
> +	mutex_unlock(&ub->mutex);
> +	cancel_delayed_work_sync(&ub->monitor_work);
> +}
> +
> +static int ubd_ctrl_stop_dev(struct ubd_device *ub)
> +{
> +	ubd_stop_dev(ub);
> +	return 0;
> +}
> +

