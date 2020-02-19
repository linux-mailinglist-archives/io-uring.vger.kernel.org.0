Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1572F164F9B
	for <lists+io-uring@lfdr.de>; Wed, 19 Feb 2020 21:11:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726645AbgBSULS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 19 Feb 2020 15:11:18 -0500
Received: from mail-lj1-f177.google.com ([209.85.208.177]:35042 "EHLO
        mail-lj1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726634AbgBSULS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 19 Feb 2020 15:11:18 -0500
Received: by mail-lj1-f177.google.com with SMTP id q8so1745451ljb.2
        for <io-uring@vger.kernel.org>; Wed, 19 Feb 2020 12:11:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=scylladb-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BXIC/lmHeJCfKTvX2Ns+o9lZofe/sXWCyhQlt7uxh3E=;
        b=xnj6Z1QefokRZUBOKRsw7CjqQ2CgESgIRUzSvoom9fnu6qaKNzPKwp9s+qzrQQnYsL
         ZdhNEn5dWRlXUlk2j7+8StYiBgK7qmUrl2HYxyKzQNMiEii0m171pUlXJQq/af5JYuRL
         AzhTZZIDQS9eYVmlqQXA7CPExuhkqwGPJWRNyH2TLptWJ8U3L0BbArTQJ6HeFXDvlg/F
         LgOnnojLpdMdSyI2vRSPpy8ZQRKsctyqIo7Mkm85v0npVf2z8Q1x4bwcree9jbThzy3G
         Wf+Mo8tdWLIBHHSFNQALqd3SRmjsT0+/7tDDuEGFyZZlcpXULBqQ9XYIjsdjWugM0roT
         2KFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BXIC/lmHeJCfKTvX2Ns+o9lZofe/sXWCyhQlt7uxh3E=;
        b=giW2N8uW7xldsIAVQb79YB46vFQx2VK7tOFNjXLbHukzmickyhzenO3Zz6PQt+pzkp
         dzBQy5ZEclVyApcaGyr1+Eov5WXoqFI+kaOFuIwhR3TZuzUcQMFHe9thXd3l9fYZXvWT
         8/7PZhozZu6g21+tPbemyG4Ac9rd6ML6jAuiF2GWdlGKExYSQEhuFXsw+4VJtglHa1G5
         V1UPajCSFTurJ9Tseuc9x+/c6T7MQZyBv+fAlOwoUuIM84YOidz734ePYQb+Betef1K3
         5EeL54BZRjVw/YOMpi7xiPg1oM6BJSB87QFLfrTLdeQEDRXMfAdMmEx0s2P6bIUCN/OO
         ii4w==
X-Gm-Message-State: APjAAAUyJ9g+9n/VQbw1yPDCthftVkF5e2iJ81Nmq7QbBGKOn+bEQsg9
        tv4oN7iOvfbjGxsOc34YYqUHetUOc6bnZhYYZKN3mw==
X-Google-Smtp-Source: APXvYqz0McPmf7IOkumqisrfn9+pngpByt38OeZ2z3UufPHpRFA+fVP0SA3xlqHiV55BdDzb7Ut1gVsYfPi1uP+fhTw=
X-Received: by 2002:a05:651c:1049:: with SMTP id x9mr17112080ljm.233.1582143076582;
 Wed, 19 Feb 2020 12:11:16 -0800 (PST)
MIME-Version: 1.0
References: <CAD-J=zZnmnjgC9Epd5muON2dx6reCzYMzJBD=jFekxB9mgp6GA@mail.gmail.com>
 <ec98e47f-a08f-59ba-d878-60b8cd787a1f@kernel.dk>
In-Reply-To: <ec98e47f-a08f-59ba-d878-60b8cd787a1f@kernel.dk>
From:   Glauber Costa <glauber@scylladb.com>
Date:   Wed, 19 Feb 2020 15:11:05 -0500
Message-ID: <CAD-J=zbm3a4nYvUo83UL706nhOicRC8LUh=iphWwL6inAa37RA@mail.gmail.com>
Subject: Re: crash on accept
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Avi Kivity <avi@scylladb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Feb 19, 2020 at 3:09 PM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 2/19/20 9:23 AM, Glauber Costa wrote:
> > Hi,
> >
> > I started using af0a72622a1fb7179cf86ae714d52abadf7d8635 today so I could consume the new fast poll flag, and one of my tests that was previously passing now crashes
>
> Thanks for testing the new stuff! As always, would really appreciate a
> test case that I can run, makes my job so much easier.

Trigger warning:
It's in C++.

I am finishing refactoring some of my code now. It's nothing
substantial so I am positive it will hit again. Once I re-reproduce
I'll send you instructions.

Reading the code it's not obvious to me how it happens, so it'll be
harder for me to cook up a simple C reproducer ATM.


>
> --
> Jens Axboe
>
