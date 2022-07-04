Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 958AE56566F
	for <lists+io-uring@lfdr.de>; Mon,  4 Jul 2022 15:05:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232071AbiGDNFS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 4 Jul 2022 09:05:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbiGDNFR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 4 Jul 2022 09:05:17 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 015DB64C9
        for <io-uring@vger.kernel.org>; Mon,  4 Jul 2022 06:05:16 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id o15so4823389pjh.1
        for <io-uring@vger.kernel.org>; Mon, 04 Jul 2022 06:05:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=QVCktmojyxDw4dh+cExU/9zgrqHUEBaF+AFzKLRJmMY=;
        b=AAgKK/BYCF+30tS76ZV+SUwPtRRnHbrv1+Ne0Mh2dJ0m6e1CrqR/pvgCd1F4DfX9++
         2LuVSQFn0ezKYnSCdsLXn1XnXMMsf6mMC2jtWunkJdN8u8mCxfmDH9Sd28Pl46xLaU9b
         lYzGw4kibcH3MTYmBKsgqfSkY3Hpoq9sht35mOqJ8J1znjPuSWN6K2JrhwYkxBTh8I8s
         lgNsveO80Zu40Zxqk4yVHImsTIU8XhdA8ZjHEEnWRUPrDtYGb2tqrj4kGF+h8x6IsdmW
         ftQun8hdwGDMLDaza7KweCH9ZYIw/JyQVcXcv83GMJFcPh+nh4Eiwn8IuK7gNd/UawdR
         3Nvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=QVCktmojyxDw4dh+cExU/9zgrqHUEBaF+AFzKLRJmMY=;
        b=lfgAGkjYR7KNOryNdbtCJrLqZWnQsQGUnbWrzFXl8VDPWoq1Q7yLtqOt802/lLlanA
         X2jV+OXxTG7PcQ6ddiH+5iVt7CoT+ZStFjU5jvmgu492VuySqcRGi2lUJQ0gpVvcLlT+
         lxqf+qsOi/tYyg4ezPDgCczITOsF4dt3eK8AAMmIBw8+yrgyj3CG5kE+bj/rzXOvcOKX
         mlVEwpZG1VSWoHNBgl0mnxCE63VsgEuHCWItpVgOuXoEZPopo7ingbYBLaPmStRK02Hz
         tspJeFflxFwwvuYw+XKEkHQxKXgyuafHYXouigWAPbiuWftcBtoMQCfLrFJrye7SbVEJ
         RbWg==
X-Gm-Message-State: AJIora/QC7zP4kPYvR7LSHuRp8bamYt5J6JASbSJxg9JX9tOLzIC/ZlL
        n0I4Y8dbTDhj4fl7oNPF7Yqm8w==
X-Google-Smtp-Source: AGRyM1tIZ4qdXMFB9zbxYyMrCAEoffY3XMs3KvCKUXcoehYwMIxNPnY4muz1r6B5C6LZQyDylpO/Hg==
X-Received: by 2002:a17:90b:f86:b0:1ef:90f2:884c with SMTP id ft6-20020a17090b0f8600b001ef90f2884cmr1381343pjb.91.1656939915418;
        Mon, 04 Jul 2022 06:05:15 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id z19-20020a17090ab11300b001d95c09f877sm5544998pjq.35.2022.07.04.06.05.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Jul 2022 06:05:15 -0700 (PDT)
Message-ID: <49ed1c4c-46ca-15c4-f288-f6808401b0ff@kernel.dk>
Date:   Mon, 4 Jul 2022 07:05:13 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH liburing v2 0/8] aarch64 support
Content-Language: en-US
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc:     Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Fernanda Ma'rouf <fernandafmr12@gnuweeb.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Hao Xu <howeyxu@tencent.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@gnuweeb.org>
References: <20220629175255.1377052-1-ammar.faizi@intel.com>
 <073c02c4-bddc-ab35-545f-fe81664fac13@gnuweeb.org>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <073c02c4-bddc-ab35-545f-fe81664fac13@gnuweeb.org>
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

On 7/4/22 6:52 AM, Ammar Faizi wrote:
> On 6/30/22 12:58 AM, Ammar Faizi wrote:
>> From: Ammar Faizi <ammarfaizi2@gnuweeb.org>
>>
>> Hi Jens,
>>
>> This is v2 revision of aarch64 support.
>>
>> This series contains nolibc support for aarch64 and one extra irrelevant
>> cleanup (patch #1). The missing bit from aarch64 is get_page_size()
>> which is a bit complicated to implement without libc.
>>
>> aarch64 supports three values of page size: 4K, 16K, and 64K which are
>> selected at kernel compilation time. Therefore, we can't hard code the
>> page size for this arch. In this series we utilize open(), read() and
>> close() syscall to find the page size from /proc/self/auxv.
>>
>> The auxiliary vector contains information about the page size, it is
>> located at `AT_PAGESZ` keyval pair.
> 
> This no longer applies, I will send v3 revision soon. If you have some
> comments, let me know so I can address it together with the rebase.

Just send a v3, didn't have time to go fully over it yet. One note,
though - for patch 5, I'd split get_page_size() into two pieces so you
just do:

static inline long get_page_size(void)
{
	static long cache_val;

	if (cache_val)
		return cache_val;

	return __get_page_size();
}

With that, we can have __get_page_size() just do that one thing, open
the file and read the value.

No need to init static variables to 0.

And finally, if the read/open/whatever fails in __get_page_size(),
assign cache_val to the fallback value as well. I don't see a point in
retrying the same operation later and expect a different result.

-- 
Jens Axboe

