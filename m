Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C65CC4E6B42
	for <lists+io-uring@lfdr.de>; Fri, 25 Mar 2022 00:40:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346469AbiCXXjk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Mar 2022 19:39:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356976AbiCXXiX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Mar 2022 19:38:23 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BCD9986C7
        for <io-uring@vger.kernel.org>; Thu, 24 Mar 2022 16:36:50 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id w8so6360736pll.10
        for <io-uring@vger.kernel.org>; Thu, 24 Mar 2022 16:36:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=GebMZe55xHN1I+0YXbeTh7daUrmbTo6OsaivpOl4mhM=;
        b=ZTsDnLd6GGJ/CDNND38btHDAVkn3zbXuN/5tHhxkl/olLbx9B/SxKx7u3z/q25MPmm
         6qCZwQ1+j7YORPvJZ9GBwsqPD1TGedIrtEMcCUlPYEu0Jwn+egh8rAG4RZyYYqFt83Ya
         BmP837YpxGYX8Gi76uQZIT0sue2hPve4uK1ufIGT9LY665Jbi2T0P4MNc37dEhf/VdMe
         z7c3t1lMbTUX+yAsG4sOCRETXzAWCu/ylwvScmtYLgvftncFBspdMgh/rZJSnrrugRti
         l8DKyTe5OT6sdGIWlIA+1GeI6CjaTvHAfuVLE7dymwW1MYsyr6VQX0XaDPUSM0Qb1nmQ
         2fIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=GebMZe55xHN1I+0YXbeTh7daUrmbTo6OsaivpOl4mhM=;
        b=NQxdcL9Wa2bDSDd3xNZM72UBSWCRjIAm9NK7EUFvfFseECvckmscaxwY0mzlCz1ZeM
         oUhUsOQKN/41bnmGJhmDL5MdXtrfCsuTsHxUhY3KXNcIBAKHNccMK40MKrmk0HLS8QOg
         MD4cwuZAWtobFRRejfDvGwvJehUPAgQnO8yBaBO+qVmN6jq8FG9RKySUp6EKP4iNE2nv
         RLwNi1varzKj2d+v0hKzU14ysRTM/oP8/MW2gNhDYDPnWtVUVutnEtX9hdA+xheTW++R
         TPP1pOVR6B/xdmd9LHP9rahNsieEQGoXeVmvTG+kN+xGb4HTFev8GIjeBd71FD0kuDsD
         LTOQ==
X-Gm-Message-State: AOAM531hD9+ChzmLQaZEV5T3bSaVc3RDNjYKK9y9bGXfASL0g3bNRlVJ
        R2eL0EmAqce1Oy4ZhblOMSvi2w==
X-Google-Smtp-Source: ABdhPJzqMNc0ahbFfodPumpJQOiINRzZGitX9G+hqCRFpKVPql6rpnnDAM2cR9akyaGDaLiOylrvLQ==
X-Received: by 2002:a17:90b:4f86:b0:1c6:b3eb:99a3 with SMTP id qe6-20020a17090b4f8600b001c6b3eb99a3mr9261128pjb.66.1648165009872;
        Thu, 24 Mar 2022 16:36:49 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id y9-20020a056a00180900b004faa45a2230sm4754641pfa.210.2022.03.24.16.36.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Mar 2022 16:36:49 -0700 (PDT)
Message-ID: <2e4e5faa-ca1e-75b1-b864-646270b708ed@kernel.dk>
Date:   Thu, 24 Mar 2022 17:36:46 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 17/17] nvme: enable non-inline passthru commands
Content-Language: en-US
To:     Clay Mayers <Clay.Mayers@kioxia.com>,
        Kanchan Joshi <joshi.k@samsung.com>, "hch@lst.de" <hch@lst.de>,
        "kbusch@kernel.org" <kbusch@kernel.org>,
        "asml.silence@gmail.com" <asml.silence@gmail.com>
Cc:     "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "sbates@raithlin.com" <sbates@raithlin.com>,
        "logang@deltatee.com" <logang@deltatee.com>,
        "pankydev8@gmail.com" <pankydev8@gmail.com>,
        "javier@javigon.com" <javier@javigon.com>,
        "mcgrof@kernel.org" <mcgrof@kernel.org>,
        "a.manzanares@samsung.com" <a.manzanares@samsung.com>,
        "joshiiitr@gmail.com" <joshiiitr@gmail.com>,
        "anuj20.g@samsung.com" <anuj20.g@samsung.com>
References: <20220308152105.309618-1-joshi.k@samsung.com>
 <CGME20220308152729epcas5p17e82d59c68076eb46b5ef658619d65e3@epcas5p1.samsung.com>
 <20220308152105.309618-18-joshi.k@samsung.com>
 <6a1cf782310d481aa5ef2fc172f55826@kioxia.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <6a1cf782310d481aa5ef2fc172f55826@kioxia.com>
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

On 3/24/22 3:09 PM, Clay Mayers wrote:
>> From: Kanchan Joshi
>> Sent: Tuesday, March 8, 2022 7:21 AM
>> To: axboe@kernel.dk; hch@lst.de; kbusch@kernel.org;
>> asml.silence@gmail.com
>> Cc: io-uring@vger.kernel.org; linux-nvme@lists.infradead.org; linux-
>> block@vger.kernel.org; sbates@raithlin.com; logang@deltatee.com;
>> pankydev8@gmail.com; javier@javigon.com; mcgrof@kernel.org;
>> a.manzanares@samsung.com; joshiiitr@gmail.com; anuj20.g@samsung.com
>> Subject: [PATCH 17/17] nvme: enable non-inline passthru commands
>>
>> From: Anuj Gupta <anuj20.g@samsung.com>
>>
>> On submission,just fetch the commmand from userspace pointer and reuse
>> everything else. On completion, update the result field inside the passthru
>> command.
>>
>> Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
>> Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
>> ---
>>  drivers/nvme/host/ioctl.c | 29 +++++++++++++++++++++++++----
>>  1 file changed, 25 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c index
>> 701feaecabbe..ddb7e5864be6 100644
>> --- a/drivers/nvme/host/ioctl.c
>> +++ b/drivers/nvme/host/ioctl.c
>> @@ -65,6 +65,14 @@ static void nvme_pt_task_cb(struct io_uring_cmd
>> *ioucmd)
>>  	}
>>  	kfree(pdu->meta);
>>
>> +	if (ioucmd->flags & IO_URING_F_UCMD_INDIRECT) {
>> +		struct nvme_passthru_cmd64 __user *ptcmd64 = ioucmd-
>>> cmd;
>> +		u64 result = le64_to_cpu(nvme_req(req)->result.u64);
>> +
>> +		if (put_user(result, &ptcmd64->result))
>> +			status = -EFAULT;
> 
> When the thread that submitted the io_uring_cmd has exited, the CB is
> called by a system worker instead so put_user() fails.  The cqe is
> still completed and the process sees a failed i/o status, but the i/o
> did not fail.  The same is true for meta data being returned in patch
> 5.
> 
> I can't say if it's a requirement to support this case.  It does break
> our current proto-type but we can adjust.

Just don't do that then - it's all very much task based. If the task
goes away and completions haven't been reaped, don't count on anything
sane happening in terms of them completing successfully or not.

The common case for this happening is offloading submit to a submit
thread, which is utterly pointless with io_uring anyway.

-- 
Jens Axboe

