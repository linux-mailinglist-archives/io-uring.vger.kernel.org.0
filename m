Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 364FD47763E
	for <lists+io-uring@lfdr.de>; Thu, 16 Dec 2021 16:45:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232086AbhLPPpw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Dec 2021 10:45:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231948AbhLPPpv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Dec 2021 10:45:51 -0500
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FE41C061574
        for <io-uring@vger.kernel.org>; Thu, 16 Dec 2021 07:45:50 -0800 (PST)
Received: by mail-io1-xd33.google.com with SMTP id q72so35673936iod.12
        for <io-uring@vger.kernel.org>; Thu, 16 Dec 2021 07:45:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=SBc3GAZ4YIZ93s8r+/3FQmo1yidZe9JMqHnGjAewgfA=;
        b=TV6wSRzLfaitAAev15bGgk32ATQBKLUauLBN3HJF2ETNkTpl5pszIifpP+yj0RDwIL
         4RYMlw2TagUJa01p3ziZxfwqkdBSh0Qa8Vov14hk3IhmlNLh1uQzjaGt6gt+K0f5+kRF
         4fIa16ymlTeCbf6hldLKQHYWlCxhTxKfgUsb6SodSoKs6HsbZWUMkB2bIlGW/PRLuOfU
         s6uYDzFk3tAiTAa4R5GzFQL+ncUST1uJGZFLJXW4K/afgT9MZBwGrwB25fcrXwpstlyj
         /DSJ9JrGOF8fsyMVscLoU15aR1rKwWZTkDGfGHKc+zDy8XTDgJUA+XXePVQuAbqm4whh
         ASTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SBc3GAZ4YIZ93s8r+/3FQmo1yidZe9JMqHnGjAewgfA=;
        b=1z1EaRd6InJQoLRXlcui06e0uzu+2QTz/IuiwBlJ3F7WGyTESgZK7TwnMlG1cA5/wF
         y+28oIhHTWp2WMSjsIsNHmPfF+1F12V5S0Mt5K57TAXowyRkwwAcCaKx9n7SP1WLX5S2
         6IUHdrnqo/9fYoJsPgTmvHgvg0WfWV3ohEXpWQzFdcwCP70bqLwOvIGO1nmpo3vU/TTj
         bqK+BjyqK27ryJ3jwfCiBwRewPYXIp9bp2kis5597Ne8sLbzXPYnN6KK659AVGRXRkLd
         RH+QtSPqqRqo1g/6bADJnKECadersyMTj0V/hWkaIeOKbIEcCnDfHhUKq1HNBEq96HY5
         tUEA==
X-Gm-Message-State: AOAM532qPEuKHYeFpA6eq0kUufYcx/KtDRVcLu1Zylr8iJocxBgmls3X
        8npycw30H4frKmHjD2P2P4O1AQ==
X-Google-Smtp-Source: ABdhPJxplkANgDmAeUKaQOmui2rltUUu3y+oFsyxBSdV6c9hGPou7JZdqdr7SPCy+0CdVlD+v46jsQ==
X-Received: by 2002:a05:6638:d89:: with SMTP id l9mr10226540jaj.80.1639669549784;
        Thu, 16 Dec 2021 07:45:49 -0800 (PST)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id t6sm2680980ioi.51.2021.12.16.07.45.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Dec 2021 07:45:49 -0800 (PST)
Subject: Re: [PATCH 4/4] nvme: add support for mq_ops->queue_rqs()
To:     Christoph Hellwig <hch@infradead.org>
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        Hannes Reinecke <hare@suse.de>
References: <20211215162421.14896-1-axboe@kernel.dk>
 <20211215162421.14896-5-axboe@kernel.dk> <YbsB/W/1Uwok4i0u@infradead.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <83aa4715-7bf8-4ed1-6945-3910cb13f233@kernel.dk>
Date:   Thu, 16 Dec 2021 08:45:46 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <YbsB/W/1Uwok4i0u@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/16/21 2:08 AM, Christoph Hellwig wrote:
> On Wed, Dec 15, 2021 at 09:24:21AM -0700, Jens Axboe wrote:
>> +	spin_lock(&nvmeq->sq_lock);
>> +	while (!rq_list_empty(*rqlist)) {
>> +		struct request *req = rq_list_pop(rqlist);
>> +		struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
>> +
>> +		memcpy(nvmeq->sq_cmds + (nvmeq->sq_tail << nvmeq->sqes),
>> +				absolute_pointer(&iod->cmd), sizeof(iod->cmd));
>> +		if (++nvmeq->sq_tail == nvmeq->q_depth)
>> +			nvmeq->sq_tail = 0;
> 
> So this doesn't even use the new helper added in patch 2?  I think this
> should call nvme_sq_copy_cmd().

But you NAK'ed that one? It definitely should use that helper, so I take it
you are fine with it then if we do it here too? That would make 3 call sites,
and I still do think the helper makes sense...

> The rest looks identical to the incremental patch I posted, so I guess
> the performance degration measured on the first try was a measurement
> error?

It may have been a measurement error, I'm honestly not quite sure. I
reshuffled and modified a few bits here and there, and verified the
end result. Wish I had a better answer, but...

-- 
Jens Axboe

