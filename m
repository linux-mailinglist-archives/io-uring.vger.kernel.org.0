Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BEA83E7E09
	for <lists+io-uring@lfdr.de>; Tue, 10 Aug 2021 19:12:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbhHJRMr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 10 Aug 2021 13:12:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229474AbhHJRMq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 10 Aug 2021 13:12:46 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE2D7C0613C1
        for <io-uring@vger.kernel.org>; Tue, 10 Aug 2021 10:12:23 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id u1so6115wmm.0
        for <io-uring@vger.kernel.org>; Tue, 10 Aug 2021 10:12:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=Ei1LaQ+hoHzBmWn3jW4ST+SUf/7J22alhQEeCAat1ZY=;
        b=rbRdS7fmRqHoM0yvnvCQbpPV5n+h3pdIDzQr2Jq6zk8c/oXIXF5+4POBoI3ctfmEWk
         GsNtYkuOxGf8vgex4twBSrVjU9IoQ9mSa+h90BG2bLG43eqQCyaJHfEwJH0nsmdOSssa
         imcztUv69284m95KVvPXA6pHe2KMN/3bBkYZqZ3Z1r1YczDOYQNVWKzJq2BjSh/doKbk
         6sO+cIr0mdjiCeK8ywPGc/x6ix3VXoOmhSQ8ZDx/X+bXGEU5jyxzz2o7429zhelfxH97
         KtDyjrPQz8CZyQM1CWhqKkEGAqsfiLadZzI9yPLDJKiY2qlPkWQ5iP8YyCT6jwIZ9Dtk
         mk5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ei1LaQ+hoHzBmWn3jW4ST+SUf/7J22alhQEeCAat1ZY=;
        b=rpo3HfS46HjmtAnldgvqnZGeCzRx74wYOd+HFYKWj8hmoTq49TUVhtCFAVucyIgNwg
         LuEWGMKy6/rD/IZ1OWUJ56IM5fv4WVGhIbkdJzJnWT/jJxtRg1dh4UXwZae/4dD2WSpw
         mRlHwbO/T9A2RaC/jIVHykRs3GTbCgwb6+WYcVpJNz6v4YxQNz55Oxun45kIcoHfZFUo
         zs3gc6pjWUtyoSssWW6VYtIINT57p+Ytdew0W2yspwrenKjW0M1JROi7lC/6mkS8Xd8H
         A/xbnt/o1DLFMkbQn4uaBNksuzujhlsklVorQ0vLdPIsWkEcOAIuEr/lpRMaRpoYb3/Q
         JaBg==
X-Gm-Message-State: AOAM531UdixEGilkTp+cq0EoXPWxd73lhEeS7ml5L7G5g6SFBjedMcdQ
        9EZgOaFhgZiD+C508GfXsmgRxWIP7jo=
X-Google-Smtp-Source: ABdhPJz1XuMFWcct/Wfz7GepxcSrK/g3oNp9c/Sr0fxZrgOZKIcWaWxbV6YESS0yeDQKIoAEfgL40A==
X-Received: by 2002:a05:600c:4784:: with SMTP id k4mr5895596wmo.166.1628615542238;
        Tue, 10 Aug 2021 10:12:22 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.133.97])
        by smtp.gmail.com with ESMTPSA id z12sm2715226wrn.28.2021.08.10.10.12.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Aug 2021 10:12:21 -0700 (PDT)
Subject: Re: [RFC] io_uring: remove file batch-get optimisation
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <afe7a11e30f64e18785627aa5f49f7ce40cb5311.1628603451.git.asml.silence@gmail.com>
 <be049d43-4774-c79a-8564-82d43fb87766@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <623fc711-5c20-71dd-df90-5b94ce22ca96@gmail.com>
Date:   Tue, 10 Aug 2021 18:11:52 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <be049d43-4774-c79a-8564-82d43fb87766@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/10/21 6:04 PM, Jens Axboe wrote:
> On 8/10/21 7:52 AM, Pavel Begunkov wrote:
>> For requests with non-fixed files, instead of grabbing just one
>> reference, we get by the number of left requests, so the following
>> requests using the same file can take it without atomics.
>>
>> However, it's not all win. If there is one request in the middle
>> not using files or having a fixed file, we'll need to put back the left
>> references. Even worse if an application submits requests dealing with
>> different files, it will do a put for each new request, so doubling the
>> number of atomics needed. Also, even if not used, it's still takes some
>> cycles in the submission path.
>>
>> If a file used many times, it rather makes sense to pre-register it, if
>> not, we may fall in the described pitfall. So, this optimisation is a
>> matter of use case. Go with the simpliest code-wise way, remove it.
> 
> I ran this through the peak testing, not using registered files. Doesn't
> seem to make a real difference here, at least in the quick testing.
> Which would seem to indicate we could safely kill it. But that's also
> the best case for non-registered files, would be curious to see if it
> makes a real difference now for workloads where the file is being
> shared.

Do you mean shared between cores so there is contention? Or the worst
case for non-reg with multiple files as described in the patch? 

-- 
Pavel Begunkov
