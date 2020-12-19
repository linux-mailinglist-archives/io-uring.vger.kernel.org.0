Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B6932DF23F
	for <lists+io-uring@lfdr.de>; Sun, 20 Dec 2020 00:43:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726437AbgLSXnO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 19 Dec 2020 18:43:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726421AbgLSXnO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 19 Dec 2020 18:43:14 -0500
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26A1DC0613CF
        for <io-uring@vger.kernel.org>; Sat, 19 Dec 2020 15:42:22 -0800 (PST)
Received: by mail-qt1-x829.google.com with SMTP id z9so4256247qtn.4
        for <io-uring@vger.kernel.org>; Sat, 19 Dec 2020 15:42:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JLQSE3Df83YhjQoSQNQoVE11sV8kbo06KfSCKZ6tT2c=;
        b=nwGBPyHKy5RFNlV/E99tyPy/9BtSpaTlzL20fxhF5E4UnhNajoMBrHBSxFJ29zbwLC
         UwX0qlYF2eXmdsfTHirAabIeeUkDe8Y9pG5LGckVn5fez0D+HcrrC6kQYy2hEmCX9vf2
         yd4XNPLfYM/wHPjDn3rOf0xYqHt21MU7IUXKN7smmZk3sKdqJhu+2HsEiNCUV0tgepFC
         LAoWx5kazhGt4RbtGOR6FIbUGnvtdgFBaQDobfzl+eXSt04mq4l28uH3/HFO0m8zJTaS
         pGm+uOZ84YJFOletcQg6yZ0TkYFSRIY5sHsk5eZneZlqJDS69asSksZAfMAczs3OxcDP
         D+7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JLQSE3Df83YhjQoSQNQoVE11sV8kbo06KfSCKZ6tT2c=;
        b=bEH/uWTtCLGzdm1xhkANWYRrwvB99t6KFntVsr4ywQXdFqjmoS+WRSrYAYyUfMGkrk
         uCt76Oy64a46sHB/2/rWT2qxr4IxSUNqBWQvfRYa5dkcR3234foFV9AB+2qVLOswrGJs
         rgtp7kFR34FBNxUkCUMYFH7ldyomXUaWnIIsgpCOXApVhUZwhCvL6vXYKLF6oWJTS4cC
         Y1ZLORpHtv5YmpV0z7/y0trBY+moUyg0ttA2d8aGiUdlM9aC5TVZwNJNdee68H0wqO8u
         5eemyUFdVQUAGVYkXEdNLcz/ktUPBTf9XZOsYP92fklLjdBiUKOD2h4cVO5H+eLZQk1z
         5UWQ==
X-Gm-Message-State: AOAM532jU1VL9IY7FVJmyyjDdOXNxuAwRwlXoLah/vHla3bCD6SNGwXu
        2vssOQzgAn9IFhOEYRSH/vg2jNlAK2M1TB0Hqu8=
X-Google-Smtp-Source: ABdhPJyXj0eOZT7Cu0y9LYzahs93nJlTdukMpb4PIfo9jAj4LOcVUfnytYLJfZVBuYiXIuZnQFdV4gbIJefdP7y3JPc=
X-Received: by 2002:ac8:729a:: with SMTP id v26mr10880167qto.53.1608421341089;
 Sat, 19 Dec 2020 15:42:21 -0800 (PST)
MIME-Version: 1.0
References: <4dc9c74b-249d-117c-debf-4bb9e0df2988@kernel.dk>
 <2B352D6C-4CA2-4B09-8751-D7BB8159072D@googlemail.com> <d9205a43-ebd7-9412-afc6-71fdcf517a32@kernel.dk>
 <CAAss7+ps4xC785yMjXC6u8NiH9PCCQQoPiH+AhZT7nMX7Q_uEw@mail.gmail.com>
 <0fe708e2-086b-94a8-def4-e4ebd6e0b709@kernel.dk> <614f8422-3e0e-25b9-4cc2-4f1c07705ab0@kernel.dk>
In-Reply-To: <614f8422-3e0e-25b9-4cc2-4f1c07705ab0@kernel.dk>
From:   Josef <josef.grieb@gmail.com>
Date:   Sun, 20 Dec 2020 00:42:10 +0100
Message-ID: <CAAss7+q8X83oRxTWKSh75RUO+dq-knE6KpL6bfxkbfAA+Apv1w@mail.gmail.com>
Subject: Re: "Cannot allocate memory" on ring creation (not RLIMIT_MEMLOCK)
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Norman Maurer <norman.maurer@googlemail.com>,
        Dmitry Kadashev <dkadashev@gmail.com>,
        io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

> Josef, can you try with this added? Looks bigger than it is, most of it
> is just moving one function below another.

yeah sure, sorry stupid question which branch is the patch based on?
(last commit?)

-- 
Josef
