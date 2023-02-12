Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E296E6935AA
	for <lists+io-uring@lfdr.de>; Sun, 12 Feb 2023 03:46:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229650AbjBLCqT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 11 Feb 2023 21:46:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbjBLCqS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 11 Feb 2023 21:46:18 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F029C11EBB
        for <io-uring@vger.kernel.org>; Sat, 11 Feb 2023 18:46:16 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id n20-20020a17090aab9400b00229ca6a4636so13894911pjq.0
        for <io-uring@vger.kernel.org>; Sat, 11 Feb 2023 18:46:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=13n7orFtfB4ykJMQSCkI+SVHhcT583fh+bxIuvlC7mY=;
        b=ESXg7vS2YfHpVFr9OQZAHv9M3hthBxU2Row9ea0aJR9IjQ6GL15VCoTe39SuK/apcz
         lfGM7PXnvgu0PiiAykezRpIW1FRoeZgXJJ1f5yT+0kseS0KVDaqQDpA+I+Dymcgg1zY1
         iJGmRqnL0dCDPWM41X5z2Oh7WP3Z/XxGAGv3Avnn9/JwRFp3kolnB1oZQv8VGQXmwX3d
         rD5u2DHcmPTZ0/x3/2kVydfAybYsxNmLWQeSV3+yI7B70FNGMxThFxKX2Pd0AYuzKaP5
         7cdqi426YYBSMwwbt6a0/WgGTHOQHmA3ZJ65WGdgZGheeKN3uSzavEMms8FWcLknPqQx
         PyIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=13n7orFtfB4ykJMQSCkI+SVHhcT583fh+bxIuvlC7mY=;
        b=e8sV8WBhamYKRCtOWolsImRLa/xdrvMTHga8QDlG7x+W0fZv14ayFiKfhEVX63qZHz
         Bl7MuS3/mN+tAI/Yo+E2gJH6sd5QG141k8CZ1LRECFW9AgIHJUWdVgMxXaKWV6yZPpSS
         tkoOsDC0Ih+/6gY0VrMnBB/0YJgWtgh5tVyTkncqHmXnKtMgQa2W4mVEbUJOrT0f/Zlb
         xvStrKS/BpbwMHaJmGF/gcmU2N6VU6knA9pjONpP8KB7xiPJ1mgElFo69PZWma5mMH+K
         4ZDR2VyJBtbO/iwXZVHXHN6+fekST00vTiUlwMoD/nBaHSPNt95DZWxyjOfyFeZfk1au
         UbXw==
X-Gm-Message-State: AO0yUKXSq6et8kp5bYQFRhcwSA9uUqsHkPwkxko7p60uYHFg0uZZuH8h
        A4S8g8LZ5j86TTrENOIhWbW5og==
X-Google-Smtp-Source: AK7set8Q/Jh+L5ryxfXOAajWPMV5niu5B7Z5pm8YR78FRqb1qNpO8JtR/DWeRFI2ODz7Fg0mdVhiIg==
X-Received: by 2002:a17:902:f685:b0:199:2ee:6248 with SMTP id l5-20020a170902f68500b0019902ee6248mr21267626plg.0.1676169976461;
        Sat, 11 Feb 2023 18:46:16 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id g13-20020a63be4d000000b00478ca052819sm4935737pgo.47.2023.02.11.18.46.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Feb 2023 18:46:15 -0800 (PST)
Message-ID: <467c0abe-251f-d74b-57c8-91e02bec1c05@kernel.dk>
Date:   Sat, 11 Feb 2023 19:46:14 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: copy on write for splice() from file to pipe?
Content-Language: en-US
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Ming Lei <ming.lei@redhat.com>, Andy Lutomirski <luto@kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Matthew Wilcox <willy@infradead.org>,
        Stefan Metzmacher <metze@samba.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux API Mailing List <linux-api@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Samba Technical <samba-technical@lists.samba.org>
References: <CAHk-=wiszt6btMPeT5UFcS=0=EVr=0injTR75KsvN8WetwQwkA@mail.gmail.com>
 <fe8252bd-17bd-850d-dcd0-d799443681e9@kernel.dk>
 <CAHk-=wiJ0QKKiORkVr8n345sPp=aHbrLTLu6CQ-S0XqWJ-kJ1A@mail.gmail.com>
 <7a2e5b7f-c213-09ff-ef35-d6c2967b31a7@kernel.dk>
 <CALCETrVx4cj7KrhaevtFN19rf=A6kauFTr7UPzQVage0MsBLrg@mail.gmail.com>
 <b44783e6-3da2-85dd-a482-5d9aeb018e9c@kernel.dk>
 <2bb12591-9d24-6b26-178f-05e939bf3251@kernel.dk>
 <CAHk-=wjzqrD5wrfeaU390bXEEBY2JF-oKmFN4fREzgyXsbQRTQ@mail.gmail.com>
 <Y+cJDnnMuirSjO3E@T590> <55eaac9e-0d77-1fa2-df27-4d64e123177e@kernel.dk>
 <Y+euv+zR5ltTELqk@T590> <787c3b62-f5d8-694d-cd2f-24b40848e39f@kernel.dk>
 <CAHk-=whQ_V1ZE6jhQKHDk1MKvEkjpF2Pj-OcRQRXBTMsNpA1YA@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAHk-=whQ_V1ZE6jhQKHDk1MKvEkjpF2Pj-OcRQRXBTMsNpA1YA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/11/23 11:57 AM, Linus Torvalds wrote:
> On Sat, Feb 11, 2023 at 7:33 AM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> OK, but then the ignore_sig change should not be needed at all, just
>> changing that first bit to fatal_signal_pending() would do the trick?
> 
> Right. That was my point. The 'ignore_sig' flag just doesn't make
> sense. It was a hack for a case that shouldn't exist.

Yep, just wanted to confirm that we'd _only_ do that first one and
not go to sleep later on ignoring a signal as that could lead to
issues. Your fatal signal pending suggestion is all we need.

-- 
Jens Axboe


