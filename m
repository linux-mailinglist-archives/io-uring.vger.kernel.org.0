Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B0023B2D55
	for <lists+io-uring@lfdr.de>; Thu, 24 Jun 2021 13:11:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232282AbhFXLNm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Jun 2021 07:13:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232229AbhFXLNm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Jun 2021 07:13:42 -0400
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7C4EC061574;
        Thu, 24 Jun 2021 04:11:23 -0700 (PDT)
Received: by mail-qk1-x72c.google.com with SMTP id j184so13402747qkd.6;
        Thu, 24 Jun 2021 04:11:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NHgUP1sTls3prDIr0/e0XqOGAn4B+WBgNNZWu77Qh8U=;
        b=r9ai+dwmKnq4WxxfIuCyZkrd9DKb0t+YkjBsqJXJyqsYlWwXF8QYyp0DkMggEXoGs9
         CJGFlZ8blIuYOPDrKi0BKUt52MBp5rmEsBnsVtfCu+DyITRlAg0wnEHrW0znZLhkkXcA
         yniO5dsADYB41w7fpy0g+8TEWIdtpeMcpFweVlqb7lttMJ6CtaRm4eBAscpqsVZ41Qq4
         D2YSvnEwjuQy8gGdjuCr9UMY/e692ORvjbuJ34NHtHEineTnC3lTtKwcrxwiXEiyccI4
         tUt73B8931u2BejGgclKbkwEtH9okVZxrNYjT00OrkpPHl0EC3mtAXjJVdVPRBQ/4MRo
         FxOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NHgUP1sTls3prDIr0/e0XqOGAn4B+WBgNNZWu77Qh8U=;
        b=nnyBudp4A45FjAvdtOla3OJAytKDiCgVjjDIm7AnktKAh5xxZfuH6J9IKeTL30r8T4
         b6iVJijFciBC31iyIrJzb52xueVaFgB8vQNxTAaiC9Q8+FXliyCm+EiHL/HaJ5jv8uOV
         PB0yIJ9TjVhEdAKhPDugUKolWzt/UtS9Ys34gHiD29heA3QE0CgB3TA+aH2HwEkDAFg8
         RhPC43vbbinuEreqenVlOfGhwn5WD2lkGLMk2Lz1sLFKU8UfKItz+PZs/Ad6FKfpa9E9
         SlVgP2leWO1jqXepDxK9p2C66FpeSeVwjjPjiLYdxfFzFCIP+aJSwS/gcCZ2nTIPDtiM
         lREw==
X-Gm-Message-State: AOAM531eQWJbUvcA/srlqCoz7W8PE8friyYclYFP4Xv04/iBc3saZ0sd
        W6+wBmn7TF/68OI7mA5d2iQ4NFeRtnJQuDn2OXA=
X-Google-Smtp-Source: ABdhPJzud+CQ2ddjQ1BAyj99wpUdFo7MfJsqwf4l3+j0tyt70z83UvhwFlfw8bai2z9rtBwPeFpp+oDhKURJNyLQhCA=
X-Received: by 2002:a25:6c0a:: with SMTP id h10mr4057900ybc.167.1624533082745;
 Thu, 24 Jun 2021 04:11:22 -0700 (PDT)
MIME-Version: 1.0
References: <20210603051836.2614535-1-dkadashev@gmail.com> <20210603051836.2614535-3-dkadashev@gmail.com>
 <c079182e-7118-825e-84e5-13227a3b19b9@gmail.com> <4c0344d8-6725-84a6-b0a8-271587d7e604@gmail.com>
 <CAOKbgA4ZwzUxyRxWrF7iC2sNVnEwXXAmrxVSsSxBMQRe2OyYVQ@mail.gmail.com> <15a9d84b-61df-e2af-0c79-75b54d4bae8f@gmail.com>
In-Reply-To: <15a9d84b-61df-e2af-0c79-75b54d4bae8f@gmail.com>
From:   Dmitry Kadashev <dkadashev@gmail.com>
Date:   Thu, 24 Jun 2021 18:11:11 +0700
Message-ID: <CAOKbgA4DCGANRGfsHw0SqmyRr4A4gYfwZ6WFXpOFdf_bE2b+Yw@mail.gmail.com>
Subject: Re: [PATCH v5 02/10] io_uring: add support for IORING_OP_MKDIRAT
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        linux-fsdevel@vger.kernel.org, io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Jun 23, 2021 at 6:54 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>
> On 6/23/21 7:41 AM, Dmitry Kadashev wrote:
> > I'd imagine READ_ONCE is to be used in those checks though, isn't it? Some of
> > the existing checks like this lack it too btw. I suppose I can fix those in a
> > separate commit if that makes sense.
>
> When we really use a field there should be a READ_ONCE(),
> but I wouldn't care about those we check for compatibility
> reasons, but that's only my opinion.

I'm not sure how the compatibility check reads are special. The code is
either correct or not. If a compatibility check has correctness problems
then it's pretty much as bad as any other part of the code having such
problems, no?

That said, I'll just go ahead and use the approach that the rest of the
code (or rather most of it) uses (no READ_ONCE). If it needs fixing then
the whole bunch can probably be fixed in one go (either a single patch
or a series).

Thanks for your help, Pavel!

-- 
Dmitry Kadashev
