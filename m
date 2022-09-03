Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EE3A5ABF81
	for <lists+io-uring@lfdr.de>; Sat,  3 Sep 2022 17:23:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229455AbiICPXI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 3 Sep 2022 11:23:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229720AbiICPXG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 3 Sep 2022 11:23:06 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22479578AB
        for <io-uring@vger.kernel.org>; Sat,  3 Sep 2022 08:23:05 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id x80so4496456pgx.0
        for <io-uring@vger.kernel.org>; Sat, 03 Sep 2022 08:23:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=9lWQHHw+DnX/15y129JgYC3h5cXPm6COLV+PVQqsxhc=;
        b=eJTJQSWQGpbVcgDIYNI/oGWsNV4m5crvAajHRC0UtXbD5jE2tX8iqhnzHqne3BVrti
         g86eKAShB9CL6gLF1GnZwoglWlhj7Y2gDUsKhDNv0JjKSctQCEC8UoKdmtZDaFDO2eWB
         GfHu7oi6BQrChULkim6EvVAB4FUfMkvUo4l4kR/G2pkRwms82KnYKHghOiQrzLlpbZJ1
         2j9Wq89KxN3AsDo72EEoMVX7YHnmsGgwub7yH/qBfvyzQg4zkPYxgA7KXqkkZ6MKPyfC
         qzZHIQj1W0voV3iKZzhK6jIfduAe3fyRTq6bsm+HeIXomvdYCe0RDou/O6hobKhyhqMH
         RYZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=9lWQHHw+DnX/15y129JgYC3h5cXPm6COLV+PVQqsxhc=;
        b=Q+HSKdJjVvdFv9nd+OlptRZ3A2D3WEiNpIDCyEhRB433dJWGmrApua3QN+wdGT+ZcT
         LDEhmT3A2MdQTTpIOMaEeZStfLn5eRBR/HHOmuY+REIQvcDbjRWwKSpodx3nh4K5U3El
         avzlbBMxQwGHo/VgrZ+QL/jpGzrNh3b8ZOTzCDjzLioTjc56aPPkOsK/v0suX0M+bGOL
         XkKQPcSc1lc9Tb59QtR5ZI45jfUJhEtCsWfjp/qrfetYNOrM3Z3qpAMRSkzRxLcN0lsD
         AgYL9qJTyHosBfslXRKYa5HetBR0ycq9iTbpvYzZHMqWAAewET5BoH7D6mSH7ZIiRd/S
         EfMA==
X-Gm-Message-State: ACgBeo25Ym33IPu2ecCM4iVsNgUKBRxdZmsbvPdGg/zJYNUQpn7/vNYy
        rM7F4UKlL6xzQIa6LDoGy3r26Q==
X-Google-Smtp-Source: AA6agR4xhFk4X+xEc93uZ9adAncL/jgwDD5QPh/GJaniIdMpLbS0I1S352LKsSiYHmxAjNJBMEsFBg==
X-Received: by 2002:a65:4687:0:b0:42a:8907:5c3d with SMTP id h7-20020a654687000000b0042a89075c3dmr34943431pgr.510.1662218584488;
        Sat, 03 Sep 2022 08:23:04 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id a17-20020aa79711000000b0053b0d88220csm4058856pfg.3.2022.09.03.08.23.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 03 Sep 2022 08:23:03 -0700 (PDT)
Message-ID: <feb99ddf-f03f-c18d-25b6-2f5e1b374a4a@kernel.dk>
Date:   Sat, 3 Sep 2022 09:23:02 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.2
Subject: Re: [PATCH 2/3] nvme: use separate end IO handler for IOPOLL
To:     Kanchan Joshi <joshi.k@samsung.com>
Cc:     io-uring@vger.kernel.org
References: <20220902230052.275835-1-axboe@kernel.dk>
 <CGME20220902230104epcas5p1b9bd2831a421f145e919bce7275503f0@epcas5p1.samsung.com>
 <20220902230052.275835-3-axboe@kernel.dk> <20220903095652.GB10373@test-zns>
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220903095652.GB10373@test-zns>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/3/22 3:56 AM, Kanchan Joshi wrote:
> On Fri, Sep 02, 2022 at 05:00:51PM -0600, Jens Axboe wrote:
>> Don't need to rely on the cookie or request type, set the right handler
>> based on how we're handling the IO.
>>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>> ---
>> drivers/nvme/host/ioctl.c | 30 ++++++++++++++++++++++--------
>> 1 file changed, 22 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
>> index 7756b439a688..f34abe95821e 100644
>> --- a/drivers/nvme/host/ioctl.c
>> +++ b/drivers/nvme/host/ioctl.c
>> @@ -385,25 +385,36 @@ static void nvme_uring_task_cb(struct io_uring_cmd *ioucmd)
>> ????io_uring_cmd_done(ioucmd, status, result);
>> }
>>
>> -static void nvme_uring_cmd_end_io(struct request *req, blk_status_t err)
>> +static void nvme_uring_iopoll_cmd_end_io(struct request *req, blk_status_t err)
>> {
>> ????struct io_uring_cmd *ioucmd = req->end_io_data;
>> ????struct nvme_uring_cmd_pdu *pdu = nvme_uring_cmd_pdu(ioucmd);
>> ????/* extract bio before reusing the same field for request */
>> ????struct bio *bio = pdu->bio;
>> -??? void *cookie = READ_ONCE(ioucmd->cookie);
>>
>> ????pdu->req = req;
>> ????req->bio = bio;
>>
>> ????/*
>> ???? * For iopoll, complete it directly.
>> -???? * Otherwise, move the completion to task work.
>> ???? */
>> -??? if (cookie != NULL && blk_rq_is_poll(req))
>> -??????? nvme_uring_task_cb(ioucmd);
>> -??? else
>> -??????? io_uring_cmd_complete_in_task(ioucmd, nvme_uring_task_cb);
>> +??? nvme_uring_task_cb(ioucmd);
>> +}
>> +
>> +static void nvme_uring_cmd_end_io(struct request *req, blk_status_t err)
>> +{
>> +??? struct io_uring_cmd *ioucmd = req->end_io_data;
>> +??? struct nvme_uring_cmd_pdu *pdu = nvme_uring_cmd_pdu(ioucmd);
>> +??? /* extract bio before reusing the same field for request */
>> +??? struct bio *bio = pdu->bio;
>> +
>> +??? pdu->req = req;
>> +??? req->bio = bio;
>> +
>> +??? /*
>> +???? * Move the completion to task work.
>> +???? */
>> +??? io_uring_cmd_complete_in_task(ioucmd, nvme_uring_task_cb);
>> }
>>
>> static int nvme_uring_cmd_io(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
>> @@ -464,7 +475,10 @@ static int nvme_uring_cmd_io(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
>> ??????????? blk_flags);
>> ????if (IS_ERR(req))
>> ??????? return PTR_ERR(req);
>> -??? req->end_io = nvme_uring_cmd_end_io;
>> +??? if (issue_flags & IO_URING_F_IOPOLL)
>> +??????? req->end_io = nvme_uring_iopoll_cmd_end_io;
>> +??? else
>> +??????? req->end_io = nvme_uring_cmd_end_io;
> 
> The polled handler (nvme_uring_iopoll_cmd_end_io) may get called in
> irq context (some swapper/kworker etc.) too. And in that case will it
> be safe to call nvme_uring_task_cb directly. We don't touch the
> user-fields in cmd (thanks to Big CQE) so that part is sorted. But
> there is blk_rq_unmap_user call - can that or anything else inside
> io_req_complete_post() cause trouble.

The unmap might be problematic if the data wasn't mapped. That's a slow
path and unexpected, however. Might be better to just leave the unified
completion path and ensure that nvme_uring_task_cb() checks for polled
as well. I'll give it a quick spin.

-- 
Jens Axboe
