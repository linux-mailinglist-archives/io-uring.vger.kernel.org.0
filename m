Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBBE52E1C47
	for <lists+io-uring@lfdr.de>; Wed, 23 Dec 2020 13:33:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728415AbgLWMbU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 23 Dec 2020 07:31:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726530AbgLWMbT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 23 Dec 2020 07:31:19 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D01B7C0613D3
        for <io-uring@vger.kernel.org>; Wed, 23 Dec 2020 04:30:38 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id m5so18435889wrx.9
        for <io-uring@vger.kernel.org>; Wed, 23 Dec 2020 04:30:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=SoZ1M6GGK5EUH79Grf/btUIlupW2SP+Yqp5btHtyiAo=;
        b=IDBzKHOP7hqH8vl8ViAhLkco8AQnVQRQ93i5TlCjUxSNJ23Zuv8TS/IgISq5tm+ZlB
         4H9NoqqXGFLNOO67BytA16kn1+WY5len3erNso0vGgmzFV/hgFqHztri6iL1gF9M+XWf
         Ne+Yw5QqWaDipk6kh50bitcCI0utQqSqu9kjN5OZWmJ8WJ+YDjjK6rf7D9QA40ZZOmRg
         RmTYOrCPWzapAj/SrrCAiVaKLgHi8ckYLdit3gUw6oMD0CYBJB4gJ3uzE9D7BIChavKL
         iDdK4pUHWAix4IUFKqg+4pcB+N6JFQEy2zORqTPN5BzDBDe/uC/8Zg0foGW2km8KuNhW
         RUrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=SoZ1M6GGK5EUH79Grf/btUIlupW2SP+Yqp5btHtyiAo=;
        b=jJttWdPc6lV0iyH6LbEq09q4a0yPIzZ8xXISEZo8GJwuSc+bxZTY+PMXzLUneSjx4x
         ozRcTmF2tK+d89TFiO6I0IbJzX0iyfXfWEKmuEUi3DMAeq77m6dRjp0lfJvI92jXRojX
         EZhfe/1MfAlbdluj9p1Lpo7glExQSuJd991gg3LzK+6Kogj2xkZ7T9x2WuSHFjqPvIjg
         qdazgBL+2UTsNQyIuaoWLnG4+9q+Fq7Zgfpr1oxlCqkKTrls5LfbuaPrTzctDOBl/oJt
         l62XVSiAMeAlHRpYU2bcdCeqHKcd82fNNUwYZs52cbGJ/Z19IYZUxyjl+vPlT4weIzkO
         ISAg==
X-Gm-Message-State: AOAM531vBPzNdMjifhj5huY24oLkdrrn9uDIF1zQHG/zwc3OjLZfwIeF
        vbNqnqN1J13Ix3gkBFAlj9i5WSmEXSL5rA==
X-Google-Smtp-Source: ABdhPJw7GffjfsDLTFL+507OJ84+fFbP8ZIlXD7E6FznSfRtVU6/k5fnYfLHmM2h9uJm+jLeWkrSHw==
X-Received: by 2002:adf:e452:: with SMTP id t18mr28005798wrm.177.1608726637358;
        Wed, 23 Dec 2020 04:30:37 -0800 (PST)
Received: from [192.168.8.148] ([85.255.233.85])
        by smtp.gmail.com with ESMTPSA id m8sm30918025wmc.27.2020.12.23.04.30.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Dec 2020 04:30:36 -0800 (PST)
To:     Dmitry Kadashev <dkadashev@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>, Josef <josef.grieb@gmail.com>,
        Norman Maurer <norman.maurer@googlemail.com>,
        io-uring <io-uring@vger.kernel.org>
References: <4dc9c74b-249d-117c-debf-4bb9e0df2988@kernel.dk>
 <d9205a43-ebd7-9412-afc6-71fdcf517a32@kernel.dk>
 <CAAss7+ps4xC785yMjXC6u8NiH9PCCQQoPiH+AhZT7nMX7Q_uEw@mail.gmail.com>
 <0fe708e2-086b-94a8-def4-e4ebd6e0b709@kernel.dk>
 <614f8422-3e0e-25b9-4cc2-4f1c07705ab0@kernel.dk>
 <986c85af-bb77-60d4-8739-49b662554157@gmail.com>
 <e88403ad-e272-2028-4d7a-789086e12d8b@kernel.dk>
 <2e968c77-912d-6ae1-7000-5e34eb978ab5@gmail.com>
 <CAOKbgA5YD_MxY-RqJzP7eqdkqrnQCgjRin7w29QtszHaCJqwrg@mail.gmail.com>
 <CAOKbgA7TyscndB7nn409NsFfoJriipHG80fgh=7SRESbiguNAg@mail.gmail.com>
 <58bd0583-5135-56a1-23e2-971df835824c@gmail.com>
 <da4f2ac2-e9e0-b0c2-1f0a-be650f68b173@gmail.com>
 <CAOKbgA7shBKAnVKXQxd6PadiZi0O7UZZBZ6rHnr3HnuDdtx3ng@mail.gmail.com>
 <c4837bd0-5f19-a94d-5ffb-e59ae17fd095@gmail.com>
 <CAOKbgA5=Z+6Z-GqrYFBV5T_uqkVU0oSqKhf6C37MkruBCKTcow@mail.gmail.com>
 <CAOKbgA70CtfmM7-yFRcGTzJdgoF41MQt7mLC7L_s8jcnrtkB=Q@mail.gmail.com>
 <CAOKbgA4eihm=MyiVZSG03cxjks6=yw5eTr-dCBXmhQWmkK4YEg@mail.gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: "Cannot allocate memory" on ring creation (not RLIMIT_MEMLOCK)
Message-ID: <bd038e98-df86-ce76-554e-17e039963a76@gmail.com>
Date:   Wed, 23 Dec 2020 12:27:14 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <CAOKbgA4eihm=MyiVZSG03cxjks6=yw5eTr-dCBXmhQWmkK4YEg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 23/12/2020 11:48, Dmitry Kadashev wrote:
> On Wed, Dec 23, 2020 at 4:38 PM Dmitry Kadashev <dkadashev@gmail.com> wrote:
>> Please ignore the results from the real box above (5.9.5). The memlock limit
>> interfered with this, since our app was running in the background and it had a
>> few rings running (most failed to be created, but not all). I'll try to make it
>> fully stuck and repeat the test with the app dead.
> 
> I've experimented with the 5.9 live boxes that were showing signs of the problem
> a bit more, and I'm not entirely sure they get stuck until reboot anymore.
> 
> I'm pretty sure it is the case with 5.6, but probably a bug was fixed since
> then - the fact that 5.8 in particular had quite a few fixes that seemed
> relevant is the reason we've tried 5.9 in the first place.
> 
> And on 5.9 we might be seeing fragmentation issues indeed. I shouldn't have been
> mixing my kernel versions :) Also, I did not realize a ring of size=1024
> requires 16 contiguous pages. We will experiment and observe a bit more, and
> meanwhile let's consider the case closed. If the issue surfaces again I'll
> update this thread.

If fragmentation is to blame, it's still a problem. Let us know if you find out
anything. And thanks for keeping debugging

-- 
Pavel Begunkov
