Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F0B520BAF5
	for <lists+io-uring@lfdr.de>; Fri, 26 Jun 2020 23:08:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725975AbgFZVIg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 26 Jun 2020 17:08:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725793AbgFZVIg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 26 Jun 2020 17:08:36 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 088E9C03E979
        for <io-uring@vger.kernel.org>; Fri, 26 Jun 2020 14:08:36 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id g139so5871741lfd.10
        for <io-uring@vger.kernel.org>; Fri, 26 Jun 2020 14:08:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HP6JEmY5B4tW7UxuDiXmLLsxhIz4PuWSQqZRXdiMiM4=;
        b=XOf9XRWBKY7wh2K2cpWbzS9VrkKazM+w/OgF+YM7mntB6Ruh3Oe7ntWQ7pHF5ULQPN
         jiSt3V7/T82wtKb0iLDVqOdlpOwU1p1Crjyptk/v7rkA4nVAVKuGrtwzQ5f5oXPpIs3y
         jcqH82oXxn7xGw23l2K1yhZonGtIAnSR3+WLOHtI7gQEO59eU+BQYbEd5xr70ZsG2PbF
         XJ7pUIZyCi5ZeUIetiIg5vVm23OR3/2yeH4eMw4c0apUHTkedcE3KJiIEjUQh4w/w6Cv
         ssWlsYeeBlpExnw9claKX99UCVL7j7/yPhfITwOSgoOL8TiEi/y5zxl75i8qvpLqMjFS
         Ac7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HP6JEmY5B4tW7UxuDiXmLLsxhIz4PuWSQqZRXdiMiM4=;
        b=KEAq0u8O6ZRvC5QK6fP9eGP1ciWtJonR0uXm2ghyFWsd4tjRJI4ZpH9ibnG3mRfZFl
         buveoDdobWmeVnJCCjUDSaS1w6ucBP8hQG3JrsB1EyIdE7+dzoVpZFA6sUX1KnSUQzwA
         QsEVp6H7CHME8smN+xR7gjNhG9thNEJUOma+ix/sTwgPZE5eTejTy0q6ZUmERQVLTBbd
         /9/1LlkkOK+gkpDrKaAYh8Vn+z8I1cyYNeKlqkWGkhhXbzFJ3Nojuty4YC6XcBIyCJzH
         RNXYql1eqOaSWsAIzjFbIo5aNU5qCq+9Jn2KQCF5rpPC8lHoIOxqE5nJHhZbroVdjiFe
         ANwQ==
X-Gm-Message-State: AOAM530yxYLnCKzqDS0old1jdl+0mURqML8uftfJOa+0DdP5hBMdmRLL
        WUDTjQSNT0Svm7Uyj4Iz4sDMWciTROrf2OrryhjC776Gd9I=
X-Google-Smtp-Source: ABdhPJxhBteAQerxdRS3PSR/ocRFtD5fkv+zCChDsPxcxG/jhHX9TuvCzA/GGdg9ypcPwfx37UHe0zfoyGbl7JqRyeI=
X-Received: by 2002:a19:ac03:: with SMTP id g3mr2812297lfc.164.1593205714275;
 Fri, 26 Jun 2020 14:08:34 -0700 (PDT)
MIME-Version: 1.0
References: <bRmxY0zzqGcGWE4Xg-O3jlU42WtEEMUb4iGvfOvesLybmoDNJ242_9phm-DHLM8zJzu7C63iKCZq4ZJLcrYXnuVewHvCgiO21tW2CSuabnE=@remexre.xyz>
In-Reply-To: <bRmxY0zzqGcGWE4Xg-O3jlU42WtEEMUb4iGvfOvesLybmoDNJ242_9phm-DHLM8zJzu7C63iKCZq4ZJLcrYXnuVewHvCgiO21tW2CSuabnE=@remexre.xyz>
From:   Jann Horn <jannh@google.com>
Date:   Fri, 26 Jun 2020 23:08:08 +0200
Message-ID: <CAG48ez2-FviP63K8bX+vTatb3RL5ZZ9q0nwrW11iTsknWTUy3Q@mail.gmail.com>
Subject: Re: sendto(), recvfrom()
To:     Nathan Ringo <nathan@remexre.xyz>
Cc:     "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Jun 26, 2020 at 10:47 PM Nathan Ringo <nathan@remexre.xyz> wrote:
> Would adding IORING_OP_{SENDTO,RECVFROM} be a reasonable first kernel
> contribution? I'd like to write a program with io_uring that's listening
> on a UDP socket, so recvfrom() at least is important to my use-case.

What is the benefit compared to IORING_OP_RECVMSG and
IORING_OP_SENDMSG, which already exist (and provide a superset of
sendto/recvfrom)?
