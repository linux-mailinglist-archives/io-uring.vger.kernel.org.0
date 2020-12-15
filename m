Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29B422DAEA4
	for <lists+io-uring@lfdr.de>; Tue, 15 Dec 2020 15:12:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728283AbgLOOKW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 15 Dec 2020 09:10:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729275AbgLOOJn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 15 Dec 2020 09:09:43 -0500
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9339AC061282;
        Tue, 15 Dec 2020 06:08:57 -0800 (PST)
Received: by mail-wm1-x343.google.com with SMTP id a3so18612052wmb.5;
        Tue, 15 Dec 2020 06:08:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=IJwMYXZybCxJT0UHVVdIgfuOq3K54a+9Y/EpPWFpv/0=;
        b=eVXRaLFMJRqh7EtstSBOKNO6tJ4yUKa28N9ZGhkpLq+N+ciYCyvZRvn3XxjguI/U2M
         EzZt0wjil3zjy86ENb0suvcWF41egiXxNos6lkx4QCtSIzo4fphc7B6cLdGqoEURVrFf
         za8HjMp2ciqnBrlmRd8gaykyftQGs+vMA8Go7vb4SUIVu4sOI7GcY3QytCh5l9PbMxu4
         IXiF1MbLfbZhMwd2CHQotw/NPedTmw+K35iWgewi5jT0ADKzvqeVB6WrbcrN/vsEOE/9
         do9dykgLxRCJZEqKIYfezOahnF4eskXBTycj9Zja5KX+tsonMWdpgg1tL3kDBFiHWsl+
         GPKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=IJwMYXZybCxJT0UHVVdIgfuOq3K54a+9Y/EpPWFpv/0=;
        b=cBBDxdIABrugYb1DlhDNFaVB+/WhUE+ifPlSO2SDdFwTCKdwBZerYlrvWo3Sb42zrX
         CaUPWZXnWfAyyOTM/kEXr5IwpVlNn1vZSOGvDKCxfX+A+DL99RfyBYkfExkkclUh5PWO
         /pPggCxE34x0DohPJCWC4hXa1aD4WDg0PEtndC+alYWAOSK1w/sMhFZF59AgtI2sT7xf
         emqyzUmwrtzqtxKi/aqHUKcsuOGftKxnPbQB5a87Yv5yQ0lkNGk1e+0Q/n4HAeoWd56+
         w8NPb3ZXIODzuGURZFVLIy2AVdGhBG9ytBalyDK/9QMualCr2oNXknpUYoh75kRlLgu8
         +LvA==
X-Gm-Message-State: AOAM531LPd61frw+jnHwDUON5F+JUd7MmWIHcFmAls7jU9h0qlbLMeSI
        usXgg3NbqzU9KSRDNfrhnIrvzA4BAJ3/4J7Y
X-Google-Smtp-Source: ABdhPJyWDj2cYrF/oujgWz5P30oSEMUlwkpU/DSaAHrYgy/IZqHJpoXuaMOofStO5CgxkDkwCZ5VpQ==
X-Received: by 2002:a1c:220a:: with SMTP id i10mr32886712wmi.93.1608041336013;
        Tue, 15 Dec 2020 06:08:56 -0800 (PST)
Received: from [192.168.8.128] ([185.69.144.228])
        by smtp.gmail.com with ESMTPSA id z8sm37038733wmg.17.2020.12.15.06.08.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Dec 2020 06:08:54 -0800 (PST)
To:     Ming Lei <ming.lei@redhat.com>
Cc:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@infradead.org>,
        Matthew Wilcox <willy@infradead.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, target-devel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-doc@vger.kernel.org
References: <cover.1607976425.git.asml.silence@gmail.com>
 <20201215014114.GA1777020@T590>
 <103235c1-e7d0-0b55-65d0-013d1a09304e@gmail.com>
 <20201215120357.GA1798021@T590>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH v1 0/6] no-copy bvec
Message-ID: <e755fec3-4181-1414-0603-02e1a1f4e9eb@gmail.com>
Date:   Tue, 15 Dec 2020 14:05:35 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20201215120357.GA1798021@T590>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 15/12/2020 12:03, Ming Lei wrote:
> On Tue, Dec 15, 2020 at 11:14:20AM +0000, Pavel Begunkov wrote:
>> On 15/12/2020 01:41, Ming Lei wrote:
>>> On Tue, Dec 15, 2020 at 12:20:19AM +0000, Pavel Begunkov wrote:
>>>> Instead of creating a full copy of iter->bvec into bio in direct I/O,
>>>> the patchset makes use of the one provided. It changes semantics and
>>>> obliges users of asynchronous kiocb to track bvec lifetime, and [1/6]
>>>> converts the only place that doesn't.
>>>
>>> Just think of one corner case: iov_iter(BVEC) may pass bvec table with zero
>>> length bvec, which may not be supported by block layer or driver, so
>>> this patchset has to address this case first.
>>
>> The easiest for me would be to fallback to copy if there are zero bvecs,
>> e.g. finding such during iov_iter_alignment(), but do we know from where
>> zero bvecs can came? As it's internals we may want to forbid them if
>> there is not too much hassle.
> 
> You may find clue from the following link:
> 
> https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg2262077.html

Thanks for the link!

Al, you mentioned "Zero-length segments are not disallowed", do you have
a strong opinion on that? Apart from already diverged behaviour from the
block layer and getting in the way of this series, without it we'd also be
able to remove some extra ifs, e.g. in iterate_bvec()

-- 
Pavel Begunkov
