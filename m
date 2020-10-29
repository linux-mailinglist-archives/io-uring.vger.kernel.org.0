Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A7E629DFDF
	for <lists+io-uring@lfdr.de>; Thu, 29 Oct 2020 02:05:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730042AbgJ2BFa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 28 Oct 2020 21:05:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731271AbgJ2BFa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 28 Oct 2020 21:05:30 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7B78C0613CF
        for <io-uring@vger.kernel.org>; Wed, 28 Oct 2020 18:05:29 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id a200so922232pfa.10
        for <io-uring@vger.kernel.org>; Wed, 28 Oct 2020 18:05:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=6h1i3erNMU0OI4kGTHvI0gG7SVAQNkGyV6EziGbgnSo=;
        b=lESbMBWEpsteo5mZZHAr+WkqTAiXRTCpNOLEPCt0MA0d2EGaq5tWKaV86EfIPRxBFC
         lb7X80acKCBSVBHAH3rYy5Yi0L1K6I0ovzvDyeJzYH/4GYa/TDxJsTxpBEvBqjPQVOYl
         dF6Hwtvgwg7LCxmVXu5m9y+DpRhTnDkBucZyRIV6LBltoCm4tSL3ETQoHc0XPuBAiLwG
         A7c3JSMwVJ7TuGriAPBTzzANpShcIw0WaPgAXenPJNbUudKxEa55zjpQ3NFpDtOw7uPb
         +0mdz6TNStWde6ipL7tIbnnSoWCvSfVEXBHcE73bT8QQCveHc2DgPcY+OHOloXgg0vxR
         2ang==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6h1i3erNMU0OI4kGTHvI0gG7SVAQNkGyV6EziGbgnSo=;
        b=OaCISbUBwQT0XpKnQPvvsIN7/WjEWwuDTWxmZW/7DZ+ozBBl58TD/UB79hJngcwMFu
         BSwLYCbvTLqaFIYAmvHBx4s1BRg9ER4IDu4fzFH9dsVrFRhBsDF+/zqs71VGWy/QIYTx
         oPopEkpmy2vkMrP9OkEOrT/8N3lCSAyP6e7iutFU1zSnilXWekVZXO8GO1JwrJ9tIb9p
         LecpDvdNF8N34faQLZpnWemeITOw5IC/sBlKp3KrpkfE5prc7RuLzwh5LzvQSg78/fWb
         Y65ojAuC7273daO5BxnWkKbpllLL7gffBA1bMrkaRX9Rm8vIUZNy86AgA016mTbsJx1a
         /ASg==
X-Gm-Message-State: AOAM533pGHGCYiGyhzgOtLzSMSmgfx+E2azaTnoUR8F57D3MJb2ym1wF
        MLx+4mmfeCFaHd2dmG59zXfoRL57+oyhRw==
X-Google-Smtp-Source: ABdhPJx9+mHn4qYaUqWyIZvjRXy2BcLpUb4NxLNlFwvMePgLbgH8NtQE9lzFgbGoxeDv8cKz35FpUw==
X-Received: by 2002:a62:c1c5:0:b029:155:2a10:504f with SMTP id i188-20020a62c1c50000b02901552a10504fmr1831352pfg.13.1603933529017;
        Wed, 28 Oct 2020 18:05:29 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id 14sm565745pjn.48.2020.10.28.18.05.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Oct 2020 18:05:28 -0700 (PDT)
Subject: Re: [PATCH] Fix compilation with iso C standard
To:     Simon Zeni <simon@bl4ckb0ne.ca>, io-uring@vger.kernel.org
References: <C6OYVIZP1Q2H.2KH87B0QGDQ70@gengar>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <9de0dec7-e1bb-39fc-a175-9e6e0ea5cbb3@kernel.dk>
Date:   Wed, 28 Oct 2020 19:05:27 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <C6OYVIZP1Q2H.2KH87B0QGDQ70@gengar>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/28/20 7:00 PM, Simon Zeni wrote:
> On Wed Oct 28, 2020 at 12:31 PM EDT, Jens Axboe wrote:
>> All of this good stuff should be in the commit message before
>> the '---' or it won't make it into the git log. Which would be a
>> shame!
>>
>> I get a bunch of these with this applied:
>>
>> In file included from /usr/include/x86_64-linux-gnu/sys/types.h:25,
>> from setup.c:4:
>> /usr/include/features.h:187:3: warning: #warning "_BSD_SOURCE and
>> _SVID_SOURCE are deprecated, use _DEFAULT_SOURCE" [-Wcpp]
>> 187 | # warning "_BSD_SOURCE and _SVID_SOURCE are deprecated, use
>> _DEFAULT_SOURCE"
>> | ^~~~~~~
> 
> I didn't want to fill the commit message with my patch explanation but I
> can make a v2 to fix that definition warning and add the text into the
> commit if you want.

That's what it's there for! The commit message is basically useless
without that added, the only bit you left is a throw-away.

-- 
Jens Axboe

