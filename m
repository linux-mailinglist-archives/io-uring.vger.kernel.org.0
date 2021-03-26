Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDED834A66C
	for <lists+io-uring@lfdr.de>; Fri, 26 Mar 2021 12:27:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229671AbhCZL1N (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 26 Mar 2021 07:27:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbhCZL0l (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 26 Mar 2021 07:26:41 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F122C0613AA
        for <io-uring@vger.kernel.org>; Fri, 26 Mar 2021 04:26:40 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id h13so5899297eds.5
        for <io-uring@vger.kernel.org>; Fri, 26 Mar 2021 04:26:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nametag.social; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=j8PS7SqCTxnJMuyWS/YgfS4SBE48wr1nTpVaZme8Xxk=;
        b=WEOiFm+wqvfGz4QkNaV116m+vPYxZos9YLsRSU4B3vB2GTqdBaNnfIPERgOuazCapA
         9VSNf7DLjiepibDuH6AJeaH/Oa9haD2CKbBg7JJN+Y7SRuXtQb7RwE6X2oF0SrMODg0+
         2Uo6Ch+bqQrK+Owm2wd4kLC0eys0OTTTC9LxrJVYS+FXcjxyCs3viDkVUtCfRyLn5Aq6
         B06lo85leJUS2tmDyUFRP5nR+RqfP7PAnDJ9L6pnM4g5QLhvCvS2HZtIALrPQijL5Y8g
         u8RBxGflq0xW38ifx72BL4JxteH0kV9yw3E6n/7rmacw12ZPM6wf5xw9II7HB2X/KdXq
         VxmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=j8PS7SqCTxnJMuyWS/YgfS4SBE48wr1nTpVaZme8Xxk=;
        b=nFI66Di1yfLq6WWeCmlm8oFx14dDEzKhuk2CvfEPoQeq4uCpbSeE9c2s9t00Y7+6rQ
         LSoucy/y/rLbxcqJYU1Tn1hf/xRP8wmEsB3UzdXVfHqjO4opqoAoFYGy0zR2ulCaRE+U
         rgoCohG1aIZ5BsM4t10KfN4o2t3mp/1V61VhMk7otIUutIcr8RJiVGN0k9qI5goZq1NL
         9YpC8W6jNKSxoAz0bxPB3dFNUteSsyREC5yfEhFaacR5p5n379xLpWwWbBnj3QI4cxvi
         abxMSH4Lee5tYvL6W66tfx64p9linKN2/14UIKxTH0Jxe/4VJzK3UWWIVYqcLy30nxde
         0yhg==
X-Gm-Message-State: AOAM533UvaB3mkSobBcEM9yTm0UwgPV2ZJ7UjcSnGU4yvmwkGdml6Xlu
        MuOwOrNmn4Op9qmyXzoYw1t/5CswQgNCrZAEfU+6X3bm6HU=
X-Google-Smtp-Source: ABdhPJxGyp73t1QPC7e6PHX+Asf6GCPZLH9HuJ4LiVcM7YzABRClNS8aXZTyyVyb4DYp5B2X+3qx6UWxkKpqqG1V3MQ=
X-Received: by 2002:aa7:cf14:: with SMTP id a20mr14332262edy.49.1616757998963;
 Fri, 26 Mar 2021 04:26:38 -0700 (PDT)
MIME-Version: 1.0
References: <CAM1kxwjT66zgh8k=Jnkhn5-UHrBfMjSDyKyrKhuhtCESo9tMew@mail.gmail.com>
In-Reply-To: <CAM1kxwjT66zgh8k=Jnkhn5-UHrBfMjSDyKyrKhuhtCESo9tMew@mail.gmail.com>
From:   Victor Stewart <v@nametag.social>
Date:   Fri, 26 Mar 2021 07:26:28 -0400
Message-ID: <CAM1kxwj9htw+9435L_HiAxW6uNdN+4mUM4wcfv0NLVwez1GeHA@mail.gmail.com>
Subject: Re: [POSSIBLE BUG] sendmsg ops returning -ETIME
To:     io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Mar 25, 2021 at 11:35 PM Victor Stewart <v@nametag.social> wrote:

> let me know what data i can extract so we can quickly rule this
> definitely my bug or definitely an io-uring bug. it's really the
> bizzare -ETIME that makes me think it might not be mine.
>
> the code is super brief, check perf.networking.cpp
>
> https://github.com/victorstewart/quicperf

haha sorry for the false alarm. within 2 seconds of waking up i
realized that i'm reading past the end of the ring!
