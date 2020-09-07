Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7211325FD86
	for <lists+io-uring@lfdr.de>; Mon,  7 Sep 2020 17:51:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730111AbgIGPvd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 7 Sep 2020 11:51:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730141AbgIGPv3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 7 Sep 2020 11:51:29 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1363FC061573
        for <io-uring@vger.kernel.org>; Mon,  7 Sep 2020 08:51:29 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id c196so3338842pfc.0
        for <io-uring@vger.kernel.org>; Mon, 07 Sep 2020 08:51:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=VEkg4HthHW9U03ykNKC5LBNxNi+/Y85NP59JOTGdSdo=;
        b=Qubr/c4VQ3pDaJmarDN87KaHqXcHO5cNvF+Qvh37gcYXUaMuvjTNegokk1/hAg38ky
         rjzZJS3r7TuA08epFcAwMpYSewFHcHz9G/7O5ZHTcrRe6kKI9P89qtlmUrqP/juKeQqu
         Dj9YSo8os+RCLZH7WzH4WW0q3fJZp4sQ1mLpVndqLzFq8MRfWjqCb3ZnawcDcDmQaNw6
         Xnrp1clihFn7dHp9PWPvFPyQKffrtjDmkwm6H5vrmHY2wOBL8Amsz202+SlG8tukBDT4
         Ka1YlYPt3c/firU9Iffh07LBA1l9LdEXqzxPP+r6HbJPd9e445UAaP+CRf0mBvFS/jv0
         Sgaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VEkg4HthHW9U03ykNKC5LBNxNi+/Y85NP59JOTGdSdo=;
        b=UYDimvMGaotrgBCjGKimtEBjtjIfAq2ZARPwOZg8nJrplNCbL2kIc5aYjeDfG01jfj
         EI9ovMPgYmRf+Egm1gX6fAH6TYFxa9IjtX8rA0ZGJGIoygAaJmI/RhcPXIBvtUZMYGjD
         hO59EUveqwKg8QqqAuyTFtnpPgF0vneiuPtqztgcKddRvVkjqtxoQ5lzjZiB5rHbWqH/
         LnZF5RSvpVJ7hwO4FJOlvj6qJxrXWBbtVwwQj+vc/nen9cJyCCNkdt8rd/aK8DLJgIvG
         jvVv2kVqhLQW+fUSsJtprWL7Kl6EztZz+8ap+GmmhgkqiY0V8h4j9uyDeT8gHKvt6Jgn
         9FAQ==
X-Gm-Message-State: AOAM530BF2WrIF3wxv58YHfB5HjGY4Qn12nF6YmL2wymDzAYwO+wQZix
        sbs8TTGsFWpEcKo86IFutXrT1A==
X-Google-Smtp-Source: ABdhPJzGSSX82XGkiqR4hyDBHieFBPaEeD4EgV+Ue4Syes7Io0te9UOBwlsO4fQqVRFbf4uf/iO9TQ==
X-Received: by 2002:a62:301:0:b029:13c:1611:6587 with SMTP id 1-20020a6203010000b029013c16116587mr19757257pfd.4.1599493885399;
        Mon, 07 Sep 2020 08:51:25 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id s20sm5621578pfu.112.2020.09.07.08.51.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Sep 2020 08:51:24 -0700 (PDT)
Subject: Re: SQPOLL question
To:     Josef <josef.grieb@gmail.com>, io-uring@vger.kernel.org
Cc:     norman@apache.org
References: <CAAss7+p8iVOsP8Z7Yn2691-NU-OGrsvYd6VY9UM6qOgNwNF_1Q@mail.gmail.com>
 <68c62a2d-e110-94cc-f659-e8b34a244218@kernel.dk>
 <CAAss7+qjPqGMMLQAtdRDDpp_4s1RFexXtn7-5Sxo7SAdxHX3Zg@mail.gmail.com>
 <711545e2-4c07-9a16-3a1d-7704c901dd12@kernel.dk>
 <CAAss7+rgZ+9GsMq8rRN11FerWjMRosBgAv=Dokw+5QfBsUE4Uw@mail.gmail.com>
 <93e9b2a2-b4b4-3cde-b5a7-64c8c504848d@kernel.dk>
 <CAAss7+oa=tyf00Kudp-4O=TiduDUFZueuYvwRQsAEWxLfWQc-g@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <8f22db0e-e539-49b0-456a-fa74e2b56001@kernel.dk>
Date:   Mon, 7 Sep 2020 09:51:22 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAAss7+oa=tyf00Kudp-4O=TiduDUFZueuYvwRQsAEWxLfWQc-g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/7/20 8:58 AM, Josef wrote:
>> Yes, that is known, you cannot open/close descriptors with the
>> SQPOLL that requires fixed files, as that requires modifying the
>> file descriptor. 5.10 should not have any limitations.
> 
> ok I got it, let me know when the implementation/testing is finished
> for SQPOLL then I could test my netty implementation

If you're up for it, you could just clone my for-5.10/io_uring and base
your SQPOLL testing on that. Should be finished, modulo bugs...

-- 
Jens Axboe

