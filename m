Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 573FF6928AC
	for <lists+io-uring@lfdr.de>; Fri, 10 Feb 2023 21:50:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232979AbjBJUuS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 10 Feb 2023 15:50:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233749AbjBJUuS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 10 Feb 2023 15:50:18 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59A217F807
        for <io-uring@vger.kernel.org>; Fri, 10 Feb 2023 12:50:16 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id r8so7792960pls.2
        for <io-uring@vger.kernel.org>; Fri, 10 Feb 2023 12:50:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BOLdMOZh6oSFDZ674/JlPJ6s1A5z56hiarzibKSdCd0=;
        b=YUVcAGplnJzJGvRds7SmhH8wPnKRaEgeepF9s1F5wmgGv7LVxnxYoAPDdp5UvJT/2R
         Ld7uRFZBmvEJ+9tgHJoi15WuSw5vTiOgMPrCyrevfNTtTbRSMllCR3LRro4pPdhNDvzo
         lGu1lCnRTf8zsHJCgY8g/sAtVMQtKfN7v5mY69TFnrKV96vucUCqYhbdvWFWm5RQRxIW
         4mga/BN+7oJdbhPCHqkQI9UW7MQQr89iOk5/r/HYDx+NPGScr25yckQ+jyjBtEpnaXtd
         LbR7LjjBLKS/03heKb2TcL/2y35OvRTaKChR7BbwUCadlxhP5bRAmjFgNNsXPd8R+yqY
         l5AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BOLdMOZh6oSFDZ674/JlPJ6s1A5z56hiarzibKSdCd0=;
        b=QYLHZpBHsEm2duC+mPCvz4Gc29tNzgieQMjb2Gs+kcvbrU2xlRLbdPiwRONkBRDxWa
         OAVUKRdqizoTi+1hnvk4o8++Ez1LVjxQxJxccwdj5bPg+ahPZ2B9ttQFTKmWJv5UJ71u
         ZSPcZ94qwpxEfotHRt7Oy4HJTqFg7/2csagnmEHZDObpG6hFzMKqJEu0pio341MnYeUd
         aO9Rz61EzxNXA68wbq62xeY2587RtCcKj0an+/I55KqmqudZsqqFEWsKe9j3x2wigFOm
         0IwZGlsE+N1LgDEUHKNn9sVl4E3RT4BcdU9hn5QyRc2zQq1SCGSAYepOU9xB84FC/9Vp
         ckdg==
X-Gm-Message-State: AO0yUKXyQb3XKwGMfgbLNbtoQZUEWM0WLI5AhqhweSTzfa4KuUXEDmWa
        FehUE5CO6RLmn/7XP+IOVGyLaw==
X-Google-Smtp-Source: AK7set8i8tlrLyo/k3MJtpUjV25aKJQ2J/6HUx+X4GcdRwQFAttGDyYke7MGUbA6TE6IEUa2RpggtA==
X-Received: by 2002:a17:90a:dd45:b0:230:ca3d:3db with SMTP id u5-20020a17090add4500b00230ca3d03dbmr13943705pjv.4.1676062215811;
        Fri, 10 Feb 2023 12:50:15 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id u1-20020a17090a4bc100b002311dbb2bc5sm2586754pjl.45.2023.02.10.12.50.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Feb 2023 12:50:15 -0800 (PST)
Message-ID: <7a2e5b7f-c213-09ff-ef35-d6c2967b31a7@kernel.dk>
Date:   Fri, 10 Feb 2023 13:50:13 -0700
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
 <fe8252bd-17bd-850d-dcd0-d799443681e9@kernel.dk>
 <CAHk-=wiJ0QKKiORkVr8n345sPp=aHbrLTLu6CQ-S0XqWJ-kJ1A@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAHk-=wiJ0QKKiORkVr8n345sPp=aHbrLTLu6CQ-S0XqWJ-kJ1A@mail.gmail.com>
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

On 2/10/23 1:44 PM, Linus Torvalds wrote:
> On Fri, Feb 10, 2023 at 12:39 PM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> Right, I'm referencing doing zerocopy data sends with io_uring, using
>> IORING_OP_SEND_ZC. This isn't from a file, it's from a memory location,
>> but the important bit here is the split notifications and how you
>> could wire up a OP_SENDFILE similarly to what Andy described.
> 
> Sure, I think it's much more reasonable with io_uring than with splice itself.
> 
> So I was mainly just reacting to the "strict-splice" thing where Andy
> was talking about tracking the page refcounts. I don't think anything
> like that can be done at a splice() level, but higher levels that
> actually know about the whole IO might be able to do something like
> that.
> 
> Maybe we're just talking past each other.

Maybe slightly, as I was not really intending to comment on the strict
splice thing. But yeah I agree on splice, it would not be trivial to do
there. At least with io_uring we have the communication channel we need.
And tracking page refcounts seems iffy and fraught with potential
issues.

-- 
Jens Axboe


