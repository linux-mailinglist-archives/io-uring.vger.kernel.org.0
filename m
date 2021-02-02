Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68CA230C8D1
	for <lists+io-uring@lfdr.de>; Tue,  2 Feb 2021 19:03:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237963AbhBBSBM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 2 Feb 2021 13:01:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237741AbhBBR6R (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 2 Feb 2021 12:58:17 -0500
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63805C0613ED
        for <io-uring@vger.kernel.org>; Tue,  2 Feb 2021 09:57:36 -0800 (PST)
Received: by mail-il1-x132.google.com with SMTP id a16so2234852ilq.5
        for <io-uring@vger.kernel.org>; Tue, 02 Feb 2021 09:57:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5XgwxBrAJIjk+5iQVHO0i9EqTXWLKd9+7mFE48VNE1Q=;
        b=i7jhIBzGg7XBFlALk7RhSxBRysSgO1R19xvpNKX0//N0IfT3RYm8wdNGDDigQdaEcP
         nzcw01FK/GrLEbydT1kVPaXsWJbK6fpqQLm29KqLAPm/7bcnJo/0eV5Q8+vKtlYKtu9N
         6dV23L0FiTpV6kdUQNCAb2i3bhK8gI1unPFHlHyuceEt2peZIQ2DOx9NTMi+62Yx7AFf
         2LI1p4Muv8FWRY5HG1/yAgNObYixR79H7OohNEvJZ4apoIwsyWw5T4HLPZpULELk/8XI
         g14dSGqGOeoRoXS1uJgqRx5ENOHechavsTxiBrJfY14jpUqB1/AKGg0XT4UkLM9fysC3
         9Vbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5XgwxBrAJIjk+5iQVHO0i9EqTXWLKd9+7mFE48VNE1Q=;
        b=iR5HTeNSEgGTWq4+5j4J6COeQeWI/brhUc99eNkB9nmL/C4QXOkhj/AC3KLzNi0OCk
         6ltHnUh8qd6RTuDam6I2Nfn8a5W88GqGMWxHeLDRwAk8dtu4SusVYoweVvk8RrH7UvrJ
         tOsdFbIUKvYGNqo9XDmuakK+pX8HD4eMleASRXrhVn5zwnkqMhqbk3pXCn/fhxMbeRyR
         rSVb0Wav25LHvgGppky+65mJtKHXeNogp3sXaY57V/+SBNvwhM6avTYn3RZACdRIpiWR
         boqdB64ZNhJVxSVUOAPZLMtWcR3TLDyXeRPFMj2U8Igv7c6H/3MVLNtEZ6wwMCv3sJ0T
         Jo+w==
X-Gm-Message-State: AOAM533Ytya3BHXNyvEzkdXdmKa1c0jLKckxzuxvhxjUs5iPkkgcJywW
        qjbRFCrTyGxP4bFfNBnDtE1dzKb/E4kpCt+y
X-Google-Smtp-Source: ABdhPJwsCbFiq6MXmH2On5B1i7vqYfxJNT9VmT+5y/AxCwnMEl2n4OVyaNk/RhPgXnaD5EZrhiIesQ==
X-Received: by 2002:a05:6e02:144d:: with SMTP id p13mr19448799ilo.41.1612288655562;
        Tue, 02 Feb 2021 09:57:35 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id z16sm11257369ilp.67.2021.02.02.09.57.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Feb 2021 09:57:35 -0800 (PST)
Subject: Re: bug with fastpoll accept and sqpoll + IOSQE_FIXED_FILE
To:     Victor Stewart <v@nametag.social>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>
References: <CAM1kxwhCXpTCRjZ5tc_TPADTK3EFeWHD369wr8WV4nH8+M_thg@mail.gmail.com>
 <49743b61-3777-f152-e1d5-128a53803bcd@gmail.com>
 <c41e9907-d530-5d2a-7e1f-cf262d86568c@gmail.com>
 <CAM1kxwj6Cdqi0hJFNtGFvK=g=KoNRPMmLVoxtahFKZsjOkcTKQ@mail.gmail.com>
 <CAM1kxwg7wkB7Sj8CDi9RkssM5DwFXEFWeUcakUkpKtKVCOUSJQ@mail.gmail.com>
 <4b44f4e1-c039-a6b6-711f-22952ce1abfb@kernel.dk>
 <CAM1kxwgPW5Up-YqQWdh_cG4jvc5RWsD4UYNWN-jRRbWq5ide5g@mail.gmail.com>
 <06ceae30-7221-80e9-13e3-148cdf5e3c9f@kernel.dk>
 <1baf259f-5a78-3044-c061-2c08c37f7d58@kernel.dk>
 <CAM1kxwg7X=MzAiKs44Wx+5J2__rO7Er6892MyENRN0mwxOP_xA@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <5fa56543-5b4a-f6f8-158b-786334492d0f@kernel.dk>
Date:   Tue, 2 Feb 2021 10:57:34 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAM1kxwg7X=MzAiKs44Wx+5J2__rO7Er6892MyENRN0mwxOP_xA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/2/21 10:50 AM, Victor Stewart wrote:
>> Alright, so you're doing ACCEPT with 5.10 and you cannot do ACCEPT
>> with SQPOLL as it needs access to the file table. That works in 5.11
>> and newer, NOT in 5.10. Same goes or eg open/close and those kinds
>> of requests.
> 
> okay i must have missed that point somewhere. perfect i'll just avoid
> sqpoll until using 5.11. at least this exercise exposed some other
> issue pavel wanted to look into!

Yep, there's an issue with the newer timeouts and not breaking out of
the loop as it should.

-- 
Jens Axboe

