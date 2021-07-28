Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FAB43D8EE9
	for <lists+io-uring@lfdr.de>; Wed, 28 Jul 2021 15:23:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235227AbhG1NXN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 28 Jul 2021 09:23:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233315AbhG1NXN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 28 Jul 2021 09:23:13 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29112C061757
        for <io-uring@vger.kernel.org>; Wed, 28 Jul 2021 06:23:11 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id a4-20020a17090aa504b0290176a0d2b67aso10011066pjq.2
        for <io-uring@vger.kernel.org>; Wed, 28 Jul 2021 06:23:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tf3UHSD5uejn5HgAy+owJQfFVB+55P8SzuHzA/+KXzo=;
        b=SmjWFPeoE4TqgW9PSXNDCenY6J5tFOwAUb46FFrhQCj1RYdY/TxHhnWPt1YkWh4B1O
         ERbL5NvsJ+e9fpal3XzWNlANSHAIrmZilPOSUGrH6jriCKHJKdrd5e4/gWjG1BhAZklJ
         6K/oN6d6dSZaDga4s5mx2mcW2xSrYtqy3vAmqKD3Hitl2G+1nqTf9jwSM6GZiicAkeaQ
         +0PFDPc5Rwg3lLRw1MouJ8opgdbCUZREfsxxtjNG4dNOrromrOVroN/jUv/35cchA6+c
         XzTNKJnO3zyWF8BgFvpvJFe0YTWo+YV3chJzooGUQxY1Z2tKSqEhpb+jPtLk1ZCz4tDH
         fHsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tf3UHSD5uejn5HgAy+owJQfFVB+55P8SzuHzA/+KXzo=;
        b=Kux4ZQVd3OBfp1zI+mdP2rymgWS6K5a3WjptA2XvrB9LAijjLWEd4iIxHQ1u8OSFtf
         w/c11QbuTTNsBdvxppqBgd6ioWsfye8ZipqcGIS7hEnmMkQuoOvnDJ2gncw6aLqK41bw
         Nltj5IpQ/7poIX58XU3GOYYfcHyGaH7QgLeIlG/OO/pt+drgKf78YdHph3r3PnPjaJst
         t0N5ePFjZiU1bfQCghOHKXzY4skXJQhOkc6XbdnjviDPm3gi0t8FJZ8sHuMg0I9sHPW3
         jzMGHYcXXWprNGMOq9TOeDz/+YQLvkUvFchqRPehVVAaoVI/ymbAWVVGTS7F1tHpXolS
         ioVg==
X-Gm-Message-State: AOAM531z/cJtcR9G/mMkSF1qDNOvJd1k7qdlUfhY6cDOfog3E9JSru5Z
        wqjl+33j9dLm3Pr+Xp7sHRBilw==
X-Google-Smtp-Source: ABdhPJylzwz1I7TEx7aucqQzE+TWY6/zgnTrxKBlGSiX32Y/OvGqQBOexqknt5LFyEo/PXD/kfzBkQ==
X-Received: by 2002:a63:2bcf:: with SMTP id r198mr18809180pgr.373.1627478590552;
        Wed, 28 Jul 2021 06:23:10 -0700 (PDT)
Received: from [192.168.1.116] ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id h20sm7751854pfn.173.2021.07.28.06.23.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Jul 2021 06:23:10 -0700 (PDT)
Subject: Re: [PATCH 2/2] io_uring: don't block level reissue off completion
 path
To:     Fabian Ebner <f.ebner@proxmox.com>, io-uring@vger.kernel.org
Cc:     stable@vger.kernel.org
References: <20210727165811.284510-1-axboe@kernel.dk>
 <20210727165811.284510-3-axboe@kernel.dk>
 <70b7b7b2-c6d5-8088-ee76-c1ffc53ac2a3@proxmox.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <df686cb8-3d6e-f3ee-b767-b297434748e7@kernel.dk>
Date:   Wed, 28 Jul 2021 07:23:07 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <70b7b7b2-c6d5-8088-ee76-c1ffc53ac2a3@proxmox.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/28/21 3:26 AM, Fabian Ebner wrote:
> Am 27.07.21 um 18:58 schrieb Jens Axboe:
>> Some setups, like SCSI, can throw spurious -EAGAIN off the softirq
>> completion path. Normally we expect this to happen inline as part
>> of submission, but apparently SCSI has a weird corner case where it
>> can happen as part of normal completions.
>>
>> This should be solved by having the -EAGAIN bubble back up the stack
>> as part of submission, but previous attempts at this failed and we're
>> not just quite there yet. Instead we currently use REQ_F_REISSUE to
>> handle this case.
>>
>> For now, catch it in io_rw_should_reissue() and prevent a reissue
>> from a bogus path.
>>
>> Cc: stable@vger.kernel.org
>> Reported-by: Fabian Ebner <f.ebner@proxmox.com>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>> ---
>>   fs/io_uring.c | 6 ++++++
>>   1 file changed, 6 insertions(+)
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index 6ba101cd4661..83f67d33bf67 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -2447,6 +2447,12 @@ static bool io_rw_should_reissue(struct io_kiocb *req)
>>   	 */
>>   	if (percpu_ref_is_dying(&ctx->refs))
>>   		return false;
>> +	/*
>> +	 * Play it safe and assume not safe to re-import and reissue if we're
>> +	 * not in the original thread group (or in task context).
>> +	 */
>> +	if (!same_thread_group(req->task, current) || !in_task())
>> +		return false;
>>   	return true;
>>   }
>>   #else
>>
> 
> Hi,
> 
> thank you for the fix! This does indeed prevent the panic (with 5.11.22) 
> and hang (with 5.13.3) with my problematic workload.

Perfect, thanks for re-testing! Can I add your Tested-by to the patch?

-- 
Jens Axboe

