Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 674162AA8E4
	for <lists+io-uring@lfdr.de>; Sun,  8 Nov 2020 03:09:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728204AbgKHCJU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 7 Nov 2020 21:09:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727432AbgKHCJU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 7 Nov 2020 21:09:20 -0500
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02D2BC0613CF
        for <io-uring@vger.kernel.org>; Sat,  7 Nov 2020 18:09:20 -0800 (PST)
Received: by mail-qk1-x72a.google.com with SMTP id b18so4895350qkc.9
        for <io-uring@vger.kernel.org>; Sat, 07 Nov 2020 18:09:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=ubw74YdP1VCn7pl58UCjikjZJXWS9rjurWgZHR7uSDI=;
        b=gf5DvUZ2Hb3nxOz1BhEDu8xAAT1gMSdfBw5HDtzuD8HmObT5gn+/plIMlBLFZAfAr9
         moaHor5rCdj0XyF4QdRlI9iXW2iZ23/fAAWvHKwLxdI1dtlXmWzlzZHxPA5CHBDMG0z2
         9vXI75cb0aL8gL4lV+6qWXmuW3WVqhVkT2VvZI466s0ZVODVu0c7IVBBqbRGe6Wvidcm
         bzwOmWUatwYXf0ctEVzHyjQpVYr5FvDfDFDU+II/4E3cwwM9tpurllZVtBQ5k4cuR/wg
         G5yu/XvOkbgxCQMHzP3rcSZPGHmUvfZlqwrrm+Jv7lxRaGlW4uhICFBzddZ8Karr1POy
         tTJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=ubw74YdP1VCn7pl58UCjikjZJXWS9rjurWgZHR7uSDI=;
        b=p3WivuG0h1CF7yyZlARF+fxMbquZzqYc3p+R8uftfUgAolQQJypJTEsHmStvVa0d7k
         aaCEaA3TtZL7/QsHs6J0K4EZrDknWXccY0KqR9PiyJgqexAbg1MS3c2ZFg51z8dZJJNF
         M12+hoNKxwst0ZNmdQ59+OkJwE10u6OSFMvX6yniz8AMhrQX1ikhBz7nhwl5EXr0k2Cd
         n3VvFsJN7akCz/IbF0mJLAqKaEAREne4EQstOUJF0gDlPsmfnT9AseUTtmmb1yQoaIKH
         YR9eTlfwG4XdafYho4duS6AkcJS4FLmt21o4AlzjUWxxOXjfjhA3y/PjdRIADG1A/lfm
         qePA==
X-Gm-Message-State: AOAM530++v6sIEpcDrxI34I+yiB+f09dBCcoWI/TDtNPtlwivhlTizdm
        zMOTFLHCXwcsdw57g73PldZ/bqA+2NGNBdCEE4bNZqd2KIjPoA==
X-Google-Smtp-Source: ABdhPJwQXD9p0GdeVuvQbQFhE1xny+dCHoq9l9Lw9Lq3DaR+WcvIG2a7t1mgUw9SGwS1Qy9VuokGyTB8bgMuz8yYDDI=
X-Received: by 2002:a05:620a:16b6:: with SMTP id s22mr7859010qkj.422.1604801359128;
 Sat, 07 Nov 2020 18:09:19 -0800 (PST)
MIME-Version: 1.0
References: <24446f4e23e80803d3ab1a4d27a6d1a605e37b32.1604783766.git.asml.silence@gmail.com>
 <39db5769-5aef-96f5-305c-2a3250d9ba73@gmail.com> <030c3ccb-8777-9c28-1835-5afbbb1c3eb1@gmail.com>
 <97fce91e-4ace-f98b-1e7e-d41d9c15cfb8@kernel.dk> <a8a4ac73-81f9-f703-2f91-a70ff97e5094@gmail.com>
 <3094f974-1b67-1550-a116-a1f1fca84df2@kernel.dk>
In-Reply-To: <3094f974-1b67-1550-a116-a1f1fca84df2@kernel.dk>
From:   Josef <josef.grieb@gmail.com>
Date:   Sun, 8 Nov 2020 03:09:08 +0100
Message-ID: <CAAss7+r+DFTBcLzZhRoJ_p839nro6GKawh=te1wHPkhK9Nw4hQ@mail.gmail.com>
Subject: Re: [PATCH 5.11] io_uring: NULL files dereference by SQPOLL
To:     Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

> Josef, could you try this one?

it's weird I couldn't apply this patch..did you pull
for-5.11/io_uring? I'm gonna try manually

---
Josef Grieb
