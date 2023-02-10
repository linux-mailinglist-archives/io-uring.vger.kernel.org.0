Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FA63692A0F
	for <lists+io-uring@lfdr.de>; Fri, 10 Feb 2023 23:26:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233394AbjBJW0B (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 10 Feb 2023 17:26:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232840AbjBJW0A (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 10 Feb 2023 17:26:00 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CE497534C
        for <io-uring@vger.kernel.org>; Fri, 10 Feb 2023 14:25:59 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id a8-20020a17090a6d8800b002336b48f653so5466549pjk.3
        for <io-uring@vger.kernel.org>; Fri, 10 Feb 2023 14:25:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1676067959;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VXBM3BZPJurQG+9S0/yF7Jxgoc2wkik3nPAHNKQyPdo=;
        b=2dnOYsDrWpY6Q9SO7Yz27hs41FZUdKTa840dThiS0JCvA81scgVYZGfZ588HEWjYJx
         h50yZMB+2DNsfYenYGLA1BoQrIq3iKsZFh31wBsZ5F2/3MME40Gcts0oruqC2rGXzkrp
         rjIESvq4+M6VD3SUkw4Kcm6JnGB/UAL1beCa+y3qZwfPER8cMI9xkiCda3pgOrnpp6AT
         GjxH6mrdBt4uQwqLmfBOLLXUPmednsBvlBZ5vVeai/L8z37NFSypqnq5UuxeGBUIVUeO
         vqvR7J4CvAIjb7n0WoVWir2d7Ykj3YMne8ASZm70XCVCRz2i4AtmhU3qoGpYDdp68KgI
         PC/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1676067959;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VXBM3BZPJurQG+9S0/yF7Jxgoc2wkik3nPAHNKQyPdo=;
        b=JqBOL0WNTpXq2GTfrwGaxyC+4No4AR+iwZ0JPbbCh16Nd0JKSTAD7tpeCvdORveUtS
         3lMEMs8pCxRCf7rGKZ7KF+4U1yowrZZ4rlldDBERUS3A8CP1helhQWC3AsBXsswWvc+3
         TrSSU19Ayg3tWnV3i50AEXnHMDhFNzqSHHsWZUg5hvKcYh+m5t+XrFMymUJjMi1dBWCR
         jEawpEWJavxnNK3d++bepM2s7M55Hi3ac6K4c2eTgF3fnZNhbuebPwBtIQZlRO1FPRwm
         Q1nDPeHoAgOd3MY3j6Urlc7WrLhkcTAALtU+X1b/2z41BiqAv8raelFgi28ULuia17wL
         A/Yw==
X-Gm-Message-State: AO0yUKV8FwJPfNtkXtr1u2BSYN6uIkVZZCYNyOPKpSwLXDuutuEgZn7/
        3m8t8kYOlP6Eez+7xaEmWLyptg==
X-Google-Smtp-Source: AK7set+GrkUIVowp8cBbgQHdtPTA9kJYbebkONcykH0FZvMiCq2V47NSvr+b8gJtPFWlvvKx7UygHQ==
X-Received: by 2002:a17:903:182:b0:199:1292:53cd with SMTP id z2-20020a170903018200b00199129253cdmr17899305plg.1.1676067958914;
        Fri, 10 Feb 2023 14:25:58 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id jb1-20020a170903258100b001990c6c16ebsm3856968plb.37.2023.02.10.14.25.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Feb 2023 14:25:58 -0800 (PST)
Message-ID: <824fa356-7d6e-6733-8848-ab84d850c27a@kernel.dk>
Date:   Fri, 10 Feb 2023 15:25:56 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: copy on write for splice() from file to pipe?
Content-Language: en-US
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        Ming Lei <ming.lei@redhat.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Matthew Wilcox <willy@infradead.org>,
        Stefan Metzmacher <metze@samba.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux API Mailing List <linux-api@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Samba Technical <samba-technical@lists.samba.org>
References: <0cfd9f02-dea7-90e2-e932-c8129b6013c7@samba.org>
 <CAHk-=wjQZWMeQ9OgXDNepf+TLijqj0Lm0dXWwWzDcbz6o7yy_g@mail.gmail.com>
 <CALCETrWuRHWh5XFn8M8qx5z0FXAGHH=ysb+c6J+cqbYyTAHvhw@mail.gmail.com>
 <CAHk-=wjuXvF1cA=gJod=-6k4ypbEmOczFFDKriUpOVKy9dTJWQ@mail.gmail.com>
 <CALCETrUXYts5BRZKb25MVaWPk2mz34fKSqCR++SM382kSYLnJw@mail.gmail.com>
 <CAHk-=wgA=rB=7M_Fe3n9UkoW_7dqdUT2D=yb94=6GiGXEuAHDA@mail.gmail.com>
 <1dd85095-c18c-ed3e-38b7-02f4d13d9bd6@kernel.dk>
 <CAHk-=wiszt6btMPeT5UFcS=0=EVr=0injTR75KsvN8WetwQwkA@mail.gmail.com>
 <fe8252bd-17bd-850d-dcd0-d799443681e9@kernel.dk>
 <CAHk-=wiJ0QKKiORkVr8n345sPp=aHbrLTLu6CQ-S0XqWJ-kJ1A@mail.gmail.com>
 <7a2e5b7f-c213-09ff-ef35-d6c2967b31a7@kernel.dk>
 <CALCETrVx4cj7KrhaevtFN19rf=A6kauFTr7UPzQVage0MsBLrg@mail.gmail.com>
 <b44783e6-3da2-85dd-a482-5d9aeb018e9c@kernel.dk>
 <2bb12591-9d24-6b26-178f-05e939bf3251@kernel.dk>
 <CAHk-=wjzqrD5wrfeaU390bXEEBY2JF-oKmFN4fREzgyXsbQRTQ@mail.gmail.com>
 <CAHk-=wjUjtLjLbdTz=AzvGekyU1xiSL-wAAb7_j_XoT9t4o1vQ@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAHk-=wjUjtLjLbdTz=AzvGekyU1xiSL-wAAb7_j_XoT9t4o1vQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/10/23 3:17?PM, Linus Torvalds wrote:
> On Fri, Feb 10, 2023 at 2:08 PM Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>>
>>  (a) the first one is to protect from endless loops
> 
> Just to clarify: they're not "endless loops" per se, but we have
> splice sources and destinations that always succeed, like /dev/zero
> and /dev/null.
> 
> So things like "sendfile()" that are happy to just repeat until done
> do need to have some kind of signal handling even for the case when
> we're not actually waiting for data. That's what that whole
> 
>         /*
>          * Check for signal early to make process killable when there are
>          * always buffers available
>          */
> 
> this is all about. See commit c725bfce7968 ("vfs: Make sendfile(2)
> killable even better") for a less obvious example than that
> "zero->null" kind of thing.
> 
> (I actually suspect that /dev/zero no longer works as a splice source,
> since we disabled the whole "fall back to regular IO" that Christoph
> did in 36e2c7421f02 "fs: don't allow splice read/write without
> explicit ops").

Yet another one... Since it has a read_iter, should be fixable with just
adding the generic splice_read.

-- 
Jens Axboe

