Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D06636929E7
	for <lists+io-uring@lfdr.de>; Fri, 10 Feb 2023 23:16:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233314AbjBJWQv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 10 Feb 2023 17:16:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233325AbjBJWQs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 10 Feb 2023 17:16:48 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E74406C7C8
        for <io-uring@vger.kernel.org>; Fri, 10 Feb 2023 14:16:45 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id nn4-20020a17090b38c400b00233a6f118d0so4474982pjb.2
        for <io-uring@vger.kernel.org>; Fri, 10 Feb 2023 14:16:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1676067405;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3nq+R/MHvba6mSMNHwpnAJjpxGAz3OEgA07xNnbPejQ=;
        b=JsbSGRKKBf19CrAGTba3I8q+qoR4pRR/u15vwJb8uG9D+tlXhQskUeQChl+B0CE6/G
         d7DaFVmiOiHkRi/W9CFcG1/YBnGO6ZybityrFmb6yy+Pr+H1dmmTJaFobJbok5rmzqnw
         JMJa4yZJHmIP/hJRWaqlKMWjQKVWMlkrkHEf6G55qFnGVsQr8eE4DAVj3rzNQSwkMDow
         ygFjgS0RB5wg/DLOnrnZoXsF9rld6K/hiMVoXmQsuR+W1HorjBhYBb3VPydkcdGCf589
         +SnuVLumT+mkjXzOtA+xz7oJEt6CEYP68BxSNi+gmR3aeagBFcND2ykRP/qUq4RFhdLZ
         a9hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1676067405;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3nq+R/MHvba6mSMNHwpnAJjpxGAz3OEgA07xNnbPejQ=;
        b=tnud3l4uoruM7hkaViC47V5bZW/RdSzddEb94szv7C5dVbNMvRSZczphxFrhofsgdJ
         InkOld5RS+duuEr8VP6e02mu/0ipohr2Tu3N2PtNKcJ/F+1JBkIW2pkfJxOuZGqNSPK2
         QYsqFuyAuh7qKooazO4vUqMjfCS1XYUTzOhPXVJaPmX6ebCB56pWIRRKOtiDTsSAw9GL
         S4H5Y46f4y8heZaELhyrJIZh9o4ZKzUi8DSEOxjQ5oMcGpOkV1H0BNSUDgNb+fDwEIMG
         xurr8kuV3jeDJbsh+IPr7AND9W4jsq72VzbVk1K+VADcsrV1PvH2mmHT8/6Y3PRWLUfG
         U2lw==
X-Gm-Message-State: AO0yUKWxIIf/uCGef9ijjKWFImP80Erm5uaCpLvOquYboHDdXK1DIiaX
        tCfjNpFAt5NA+QnyzxIt7G+lwA==
X-Google-Smtp-Source: AK7set9xih2xsUwTzpXo/PHtOMC524gx4b1nt/NUfdLXSb41BaVsRdjRCGLw+94gRBxpEnPu1MVuFQ==
X-Received: by 2002:a17:902:e748:b0:19a:723a:81b2 with SMTP id p8-20020a170902e74800b0019a723a81b2mr3760922plf.5.1676067405376;
        Fri, 10 Feb 2023 14:16:45 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d21-20020a170902aa9500b0019a71017ab2sm1897737plr.91.2023.02.10.14.16.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Feb 2023 14:16:44 -0800 (PST)
Message-ID: <d89a7d6d-a40e-504d-8a6d-4d1f2c62cb41@kernel.dk>
Date:   Fri, 10 Feb 2023 15:16:43 -0700
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
 <CALCETrU-9Wcb_zCsVWr24V=uCA0+c6x359UkJBOBgkbq+UHAMA@mail.gmail.com>
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
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAHk-=wjzqrD5wrfeaU390bXEEBY2JF-oKmFN4fREzgyXsbQRTQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/10/23 3:08?PM, Linus Torvalds wrote:
> On Fri, Feb 10, 2023 at 1:51 PM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> Speaking of splice/io_uring, Ming posted this today:
>>
>> https://lore.kernel.org/io-uring/20230210153212.733006-1-ming.lei@redhat.com/
> 
> Ugh. Some of that is really ugly. Both 'ignore_sig' and
> 'ack_page_consuming' just look wrong. Pure random special cases.
> 
> And that 'ignore_sig' is particularly ugly, since the only thing that
> sets it also sets SPLICE_F_NONBLOCK.
> 
> And the *only* thing that actually then checks that field is
> 'splice_from_pipe_next()', where there are exactly two
> signal_pending() checks that it adds to, and
> 
>  (a) the first one is to protect from endless loops
> 
>  (b) the second one is irrelevant when  SPLICE_F_NONBLOCK is set
> 
> So honestly, just NAK on that series.
> 
> I think that instead of 'ignore_sig' (which shouldn't exist), that
> first 'signal_pending()' check in splice_from_pipe_next() should just
> be changed into a 'fatal_signal_pending()'.
> 
> But that 'ack_page_consuming' thing looks even more disgusting, and
> since I'm not sure why it even exists, I don't know what it's doing
> wrong.
> 
> Let's agree not to make splice() worse, while people are talking about
> how bad it already is, ok?

I was in no way advocating for this series, but it seems relevant as we
are discussing splice :-). I have pointed Ming at this discussion too.

-- 
Jens Axboe

