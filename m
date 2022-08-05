Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB06E58AED6
	for <lists+io-uring@lfdr.de>; Fri,  5 Aug 2022 19:27:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238226AbiHER12 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 5 Aug 2022 13:27:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236448AbiHER11 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 5 Aug 2022 13:27:27 -0400
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FFE8183BE
        for <io-uring@vger.kernel.org>; Fri,  5 Aug 2022 10:27:26 -0700 (PDT)
Received: by mail-il1-x12a.google.com with SMTP id p9so427857ilq.13
        for <io-uring@vger.kernel.org>; Fri, 05 Aug 2022 10:27:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=VqPDDSBpBwddRfow0SAFRaLdgUCxAuI8BMm1SRvWNRk=;
        b=TZQQewvoRD5hBKdOFT3s+LdXE6ljyWX+TGuw1pck94i1Yg9d8sLvu5ohMTLAkfgkSK
         DdYTPuhfzrG0orVYarV9B1J9erWTFt1M/slHB2OceJH2plf06thpVIgretSBwOeoVcyr
         69FDQOkWTaZHm+DYtAMNzy4tE/2DoIW6ki/di1A9Su1VgrwacDKtigkXsuvm+S4JR3DH
         YnIj0ldXTO598cfAy7hNTZdKcLLA0xnWEBmfiLI+eKlFugpMcC+Wsq8jjGHRn/e6s6iX
         bxqNntiegM7fp2rkC8q/SPnBIx0ypTH5xiVikBAooejU/Do9CG8Fzge5VEPQRzfvRUWk
         RLaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=VqPDDSBpBwddRfow0SAFRaLdgUCxAuI8BMm1SRvWNRk=;
        b=iykxSRq78ILnAbX6XjSFBiomRnNs2hbI39CtjyqkbW7Ddb9gbHg+SDgdnygZvXfRDL
         IIG8YuE2no9d5NnFFEbPbwnzR13ia05AfJmugqtSkYmRzkry3syGkeI7n0P5AeDQPrVm
         /7C8zO74MKWfnCW3rnrT3eZB43+qhzBJ8J/QgXbSe7Sxmo7zez7BbMUbjXMQFI/tgL2h
         MUVLmDmI/ixUPTlsTpi3iA4712Yle3JqEDVfBpk5KZPMKgjDDl3do1oTSCjBWjOwNiGg
         xxIQ7oW/XBgvrad+muJTmxOmRuP1Pvj3CNiaupfzv/V1bztwsN4K+vYi9JOtb4ZfnIAk
         tHMg==
X-Gm-Message-State: ACgBeo2u1UIdKx55A3uWsbisDxRH3l7hvmB9w7XVEtZP2z75LPwwLjap
        +GE44TzHvOr8Es4YTqKIp3SuLw==
X-Google-Smtp-Source: AA6agR7cmuoL/H2+7nHy2Mtu5czVX+KNmjmi5wl0z5jXuF13b3SZ+G0WaxTwgDUKt1vsaEHi65C1jA==
X-Received: by 2002:a92:cda9:0:b0:2df:a725:6491 with SMTP id g9-20020a92cda9000000b002dfa7256491mr789331ild.12.1659720445894;
        Fri, 05 Aug 2022 10:27:25 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id j9-20020a02cb09000000b0033f1953b15esm1865177jap.60.2022.08.05.10.27.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Aug 2022 10:27:24 -0700 (PDT)
Message-ID: <dcd80d2f-417e-da50-e600-b44942986699@kernel.dk>
Date:   Fri, 5 Aug 2022 11:27:22 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 0/4] iopoll support for io_uring/nvme passthrough
Content-Language: en-US
To:     Kanchan Joshi <joshi.k@samsung.com>
Cc:     hch@lst.de, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
        ming.lei@redhat.com, joshiiitr@gmail.com, gost.dev@samsung.com
References: <CGME20220805155300epcas5p1b98722e20990d0095238964e2be9db34@epcas5p1.samsung.com>
 <20220805154226.155008-1-joshi.k@samsung.com>
 <78f0ac8e-cd45-d71d-4e10-e6d2f910ae45@kernel.dk>
 <20220805171331.GD17011@test-zns>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220805171331.GD17011@test-zns>
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

On 8/5/22 11:13 AM, Kanchan Joshi wrote:
> On Fri, Aug 05, 2022 at 11:04:22AM -0600, Jens Axboe wrote:
>> On 8/5/22 9:42 AM, Kanchan Joshi wrote:
>>> Hi,
>>>
>>> Series enables async polling on io_uring command, and nvme passthrough
>>> (for io-commands) is wired up to leverage that.
>>>
>>> 512b randread performance (KIOP) below:
>>>
>>> QD_batch    block    passthru    passthru-poll   block-poll
>>> 1_1          80        81          158            157
>>> 8_2         406       470          680            700
>>> 16_4        620       656          931            920
>>> 128_32      879       1056        1120            1132
>>
>> Curious on why passthru is slower than block-poll? Are we missing
>> something here?
> passthru-poll vs block-poll you mean?
> passthru does not have bio-cache, while block path is running with that.
> Maybe completion-batching is also playing some role, not too sure about that
> at the moment.

Yeah, see other email on a quick rundown. We should make
bio_map_user_iov() use the bio caching, that'd make a big difference.
Won't fully close the gap, but will be close if we exclude the lack of
fixedbufs.

-- 
Jens Axboe

