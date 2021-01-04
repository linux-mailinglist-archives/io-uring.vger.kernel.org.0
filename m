Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A55622EA0AB
	for <lists+io-uring@lfdr.de>; Tue,  5 Jan 2021 00:23:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727094AbhADXVu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 4 Jan 2021 18:21:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726643AbhADXVu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 4 Jan 2021 18:21:50 -0500
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5623CC061574
        for <io-uring@vger.kernel.org>; Mon,  4 Jan 2021 15:21:07 -0800 (PST)
Received: by mail-oi1-x232.google.com with SMTP id s75so34058332oih.1
        for <io-uring@vger.kernel.org>; Mon, 04 Jan 2021 15:21:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=TkrMLbLDFGypq+h4KNZfRAORWJTivperluYy6Ma94uA=;
        b=T/ODGii43w1CA9PyrChzuJ0fAxINIff5eikbJ9NUssjXyuORNlhnwLEny218FrxTHf
         4KoP+gcgUV6kVGjs2H6Wei6jWB/PmoSX3GW2zHHDe+NcqpjI0/eMei+6cEU3oDZ4rGj4
         lOBA+bWDZ5mxGVFUAZzaUoYyFxinrJ3/9oPUOVVclbV5dG626jAQsvn+ZnOAMT5pjxwp
         L2hzKyyRApIXsp9kYOfIIeYt8eH7ipa6zj36p9JlXEtNA6/KWsujbhx5PdrEd28YPALl
         KZGLOeBNLVLV/cQt8aLT1EP7D5bEzLXM/KXh4y9yYPGV8fXvQnSkrUD1HAex2ogn3sWY
         VyJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TkrMLbLDFGypq+h4KNZfRAORWJTivperluYy6Ma94uA=;
        b=QxKkO+D1iWMPkKn7ZTTIMdN0UDnqXL1MOGFOaJh6Ch+HIIgI1Xi/8oCRWAJdRLgbCz
         OK07pB7pS7Kb8Qp+DNsxidbaaYbpf4KNdhQZH+yJvMb9i1j4NWJp+hWhwVoc92bNENKB
         poIUualaZ+TPIJU6e10ufDqgreiXn2JrJyrRABYOaLmKjFFWd4GSxgzZPyIsv7J1TYj6
         EZZ1qEEEwm+oZTX5Vd5mhji7wmqwrpRYh2Pb8d0TT9+SanKvetqfQYyOMT8f2K4C7HRM
         CcV54KPm/GbJmpUa1qNW4KJMlrgkkjOUuqQkzouNHLAVCFtJxA5mtVMBdlasLiMtUNL0
         YySg==
X-Gm-Message-State: AOAM530Uobiv0P4yOnGl9njyUmvksEKuS/8SVUy7TezeSpraUfD67Zdq
        qz2TUE8rMRhU4sEBnYKEMku5mcG8whzYQA==
X-Google-Smtp-Source: ABdhPJzPTbHazTrY76yoqdNWcTHzR4Ash6p8ckE3DF0oeRuyny79Y3HHBIgvNJz8/ASBsz1eTkumlQ==
X-Received: by 2002:a17:90b:8d3:: with SMTP id ds19mr987008pjb.186.1609799004713;
        Mon, 04 Jan 2021 14:23:24 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id h24sm57331747pfq.13.2021.01.04.14.23.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Jan 2021 14:23:24 -0800 (PST)
Subject: Re: [PATCH 0/2] iopoll sync fixes
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1609789890.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <204e78e5-17bb-bbcb-341f-4046fdf0b3b9@kernel.dk>
Date:   Mon, 4 Jan 2021 15:23:23 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1609789890.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/4/21 1:36 PM, Pavel Begunkov wrote:
> [previously a part of "bunch of random fixes"]
> since then:
> - 1/2, don't set mm/files under uring_lock
> - 2/2, return an overflow fast check to io_iopoll_check()
> 
> Pavel Begunkov (2):
>   io_uring: synchronise IOPOLL on task_submit fail
>   io_uring: patch up IOPOLL overflow_flush sync
> 
>  fs/io_uring.c | 91 +++++++++++++++++++++++++++------------------------
>  1 file changed, 48 insertions(+), 43 deletions(-)

Applied, thanks.

-- 
Jens Axboe

