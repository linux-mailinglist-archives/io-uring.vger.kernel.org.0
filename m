Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41340692874
	for <lists+io-uring@lfdr.de>; Fri, 10 Feb 2023 21:39:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233281AbjBJUjs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 10 Feb 2023 15:39:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232860AbjBJUjr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 10 Feb 2023 15:39:47 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58F2355E4A
        for <io-uring@vger.kernel.org>; Fri, 10 Feb 2023 12:39:46 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id w5so7704073plg.8
        for <io-uring@vger.kernel.org>; Fri, 10 Feb 2023 12:39:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1676061586;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hOgh7AvLAEWr6MHPlHv0hgSblyWQEvUMOhxbQH1+hyo=;
        b=jc2vNS6CTgDl5wGMWicplBDwMvBI5B5pqGQ9DaNZQ307PdlpVexxHxXwRO7mUkX4NY
         7fRQynw4kF8Oi2c4WShg0TbmesAXOhBwUP/ZDuN2qCO4aXUK0UZREXQBMwjpL7kmigkp
         rXAkKJ0F4wN7ACfcxYmWv6a/ZDbG/+cg82oKRyXQ/Lm+c1IogSo6u4a4+21f8ZLF0Owj
         BmISDB5fJOMG0q7j8CjfevhDocQFVyO1+tUeDOgi23M3EBTSDalxZmuN9Tnm/6svMWXF
         VB1Kb91lB3AGgf5NAATPTOY28mbd9FstMUMd9wo/WtKwHesj1wp3QpdDs4RvCAzzLbdo
         kDsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1676061586;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hOgh7AvLAEWr6MHPlHv0hgSblyWQEvUMOhxbQH1+hyo=;
        b=OqYV9FXT2OWxRmq94cNg1R9S+8UdvoDj/mWUXHBszKd+/Hc9cJ9jc3NkYp0fa26rWs
         sEOphm0Tj1LE2TA+q2ffsSwoHLnmQ8qvyuC0vyguE6CtBG8EoICrcrQYGO5Xtu2l19ID
         7r1LiUc7M2bPu8/pxrHy92HveJDODsPPhdIOGSk5XTvYXFT46UudFweLhGt4uKBwHAMD
         sba/HGSUfu5bE2TWePp47qefFUmBfotSycs4bgxWwIQlvCzfhOtgnSn0wsQYKJBawYU7
         8Y578Juj3orXkPqbKfj46+TcZGFPaIAbhCwYluD5X3uZpJR9ZhLGoJN4wc30lX5h5Sur
         xtVA==
X-Gm-Message-State: AO0yUKU4ZHu+U+whg28UHqdZubN5DlJrEHQFCkyPVty5yLn3ADgdp9UH
        483mFGpwVvC8Agn9vvoomPROKw==
X-Google-Smtp-Source: AK7set+Y8TkAMh6d9nz8+dUcs2UW1ALm0QmrsJs0TveWKd9aTsokQRTlusL/k4JePfB0Sa0dyZsGSg==
X-Received: by 2002:a17:902:f685:b0:199:190c:3c0c with SMTP id l5-20020a170902f68500b00199190c3c0cmr17850124plg.2.1676061585288;
        Fri, 10 Feb 2023 12:39:45 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id l3-20020a170903120300b00196053474a8sm3774234plh.53.2023.02.10.12.39.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Feb 2023 12:39:44 -0800 (PST)
Message-ID: <fe8252bd-17bd-850d-dcd0-d799443681e9@kernel.dk>
Date:   Fri, 10 Feb 2023 13:39:43 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: copy on write for splice() from file to pipe?
Content-Language: en-US
To:     Linus Torvalds <torvalds@linux-foundation.org>
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
 <CAHk-=wj8rthcQ9gQbvkMzeFt0iymq+CuOzmidx3Pm29Lg+W0gg@mail.gmail.com>
 <20230210021603.GA2825702@dread.disaster.area>
 <20230210040626.GB2825702@dread.disaster.area>
 <Y+XLuYh+kC+4wTRi@casper.infradead.org>
 <20230210065747.GD2825702@dread.disaster.area>
 <CALCETrWjJisipSJA7tPu+h6B2gs3m+g0yPhZ4z+Atod+WOMkZg@mail.gmail.com>
 <CAHk-=wj66F6CdJUAAjqigXMBy7gHquFMzPNAwKCgkrb2mF6U7w@mail.gmail.com>
 <CALCETrU-9Wcb_zCsVWr24V=uCA0+c6x359UkJBOBgkbq+UHAMA@mail.gmail.com>
 <CAHk-=wjQZWMeQ9OgXDNepf+TLijqj0Lm0dXWwWzDcbz6o7yy_g@mail.gmail.com>
 <CALCETrWuRHWh5XFn8M8qx5z0FXAGHH=ysb+c6J+cqbYyTAHvhw@mail.gmail.com>
 <CAHk-=wjuXvF1cA=gJod=-6k4ypbEmOczFFDKriUpOVKy9dTJWQ@mail.gmail.com>
 <CALCETrUXYts5BRZKb25MVaWPk2mz34fKSqCR++SM382kSYLnJw@mail.gmail.com>
 <CAHk-=wgA=rB=7M_Fe3n9UkoW_7dqdUT2D=yb94=6GiGXEuAHDA@mail.gmail.com>
 <1dd85095-c18c-ed3e-38b7-02f4d13d9bd6@kernel.dk>
 <CAHk-=wiszt6btMPeT5UFcS=0=EVr=0injTR75KsvN8WetwQwkA@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAHk-=wiszt6btMPeT5UFcS=0=EVr=0injTR75KsvN8WetwQwkA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/10/23 1:36 PM, Linus Torvalds wrote:
> On Fri, Feb 10, 2023 at 12:32 PM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> No, we very much do have that for io_uring zerocopy sends, which was in
>> the bit below you snipped from the reply. It'll tell you when data has
>> been sent out, and when the data has been acked.
> 
> Hmm. splice() itself definitely doesn't have that data - there's no
> "io context" for it.
> 
> There is only the pipe buffers, and they are released when the data
> has been accepted - which is not the same as used (eg the networking
> layer just takes another ref to the page and says "I'm done").
> 
> Maybe adding some io context to the pipe buffer would be possible, but
> it's certainly not obvious how, without changing splice() semantics
> completely.

Right, I'm referencing doing zerocopy data sends with io_uring, using
IORING_OP_SEND_ZC. This isn't from a file, it's from a memory location,
but the important bit here is the split notifications and how you
could wire up a OP_SENDFILE similarly to what Andy described.

-- 
Jens Axboe


