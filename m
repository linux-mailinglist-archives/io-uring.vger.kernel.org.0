Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDD15166330
	for <lists+io-uring@lfdr.de>; Thu, 20 Feb 2020 17:34:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727868AbgBTQe0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 Feb 2020 11:34:26 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:46317 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728130AbgBTQe0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 Feb 2020 11:34:26 -0500
Received: by mail-lf1-f68.google.com with SMTP id z26so3569644lfg.13
        for <io-uring@vger.kernel.org>; Thu, 20 Feb 2020 08:34:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=scylladb-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EOnOWpyM8kPtoVesoJ4p7ERnknJB5JsUQ6c+Hxs6nxA=;
        b=cV4wtsLiol3KfIWdfA7SZK86QrvmABTU2VgLkXXL4piWE056zmIDfV3JvKfIjOLiIg
         qLg+8u7NwJxFENzXwdJVUQ5LwP+yYSkedyN6J9Gv/z3mbWF1miGq1BWU3ysT2Iua1j/H
         ZZPMh/PPpErdyziH4FREhqoGjHjyuRxOuSvOPmN990HBl7TEcf7w00cqNLzsGSJbrEwa
         eJPuzUUgjgSX2u8PL5Cs5a7/ypvgmAFmxSm//JBphDWskZZRYyjD+H7wuAKXZ7fNTPv4
         R2wr9TtOE6acUuAwz0npfmabSBP4odcnrLfEmD8VpKyBMygM8JaWLde5VWCTjh8boUrY
         UmMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EOnOWpyM8kPtoVesoJ4p7ERnknJB5JsUQ6c+Hxs6nxA=;
        b=qhwSEAjY5iM1wkR3YEaBDR+NPUOEblRViErdabcgdkeR8qOSKUzLDcQjA/8kPEg9fe
         zveyINunpgPqRKknULzIQ90K7+1e2lFqAWK2wS/OMpXangilChR3JLCrBcbNYIMejdkf
         D8GEBNYLSStJRWsSrL5vh9XUT2kLod5yoKkvTh4lthZhqsnsoOUxmmaMKe+MD6B5I9HG
         dXulBa4E4Mlz8UoGkIwdAHa5vim1cL6cgdOm9ubWuL3c7/I0rjqcGUvs345MMNXug2aa
         RRPLrvJxFSgkT86ayDfTpN/tIVOjwZIsztrmpbifuBVbu3/6Y4X8UfJ6VxapzbeQYJx3
         nyfw==
X-Gm-Message-State: APjAAAVKhyRl23HQohhNtITeYoJejUAZ9X2uyFe/LgiKTv15nzclDSsP
        coUPCW2fxuyc2218r6gw25kAPIQmsinIOvB4/pZuUw==
X-Google-Smtp-Source: APXvYqxSacAFKth4/vZuw30qY2lDk6+bJYIlCsE3ZZZ1tk53qLHvHuEgmej0cvOXxGnn8KkLmB08C6Y7qSJN2P2/3lQ=
X-Received: by 2002:ac2:5b0c:: with SMTP id v12mr17137234lfn.155.1582216464371;
 Thu, 20 Feb 2020 08:34:24 -0800 (PST)
MIME-Version: 1.0
References: <CAD-J=zbBU2j=a0t2zD7k_aGqguwwkzLpPnnrOUAm2DJ3ZUJFvg@mail.gmail.com>
 <5e4904d5-e7fc-c079-e112-5b978c8fa129@kernel.dk> <7fa66eac-73d0-c461-98dd-2818434e8bc8@kernel.dk>
In-Reply-To: <7fa66eac-73d0-c461-98dd-2818434e8bc8@kernel.dk>
From:   Glauber Costa <glauber@scylladb.com>
Date:   Thu, 20 Feb 2020 11:34:13 -0500
Message-ID: <CAD-J=zbRDiK2PfXW4B=gHjKtqX1SdXHHne9TsD-NVvp-uznkHg@mail.gmail.com>
Subject: Re: crash on connect
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Avi Kivity <avi@scylladb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Feb 20, 2020 at 11:29 AM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 2/20/20 9:17 AM, Jens Axboe wrote:
> > On 2/20/20 7:19 AM, Glauber Costa wrote:
> >> Hi there, me again
> >>
> >> Kernel is at 043f0b67f2ab8d1af418056bc0cc6f0623d31347
> >>
> >> This test is easier to explain: it essentially issues a connect and a
> >> shutdown right away.
> >>
> >> It currently fails due to no fault of io_uring. But every now and then
> >> it crashes (you may have to run more than once to get it to crash)
> >>
> >> Instructions are similar to my last test.
> >> Except the test to build is now "tests/unit/connect_test"
> >> Code is at git@github.com:glommer/seastar.git  branch io-uring-connect-crash
> >>
> >> Run it with ./build/release/tests/unit/connect_test -- -c1
> >> --reactor-backend=uring
> >>
> >> Backtrace attached
> >
> > Perfect thanks, I'll take a look!
>
> Haven't managed to crash it yet, but every run complains:
>
> got to shutdown of 10 with refcnt: 2
> Refs being all dropped, calling forget for 10
> terminate called after throwing an instance of 'fmt::v6::format_error'
>   what():  argument index out of range
> unknown location(0): fatal error: in "unixdomain_server": signal: SIGABRT (application abort requested)
>
> Not sure if that's causing it not to fail here.

Ok, that means it "passed". (I was in the process of figuring out
where I got this wrong when I started seeing the crashes)

>
> --
> Jens Axboe
>
