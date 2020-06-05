Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65B871EF003
	for <lists+io-uring@lfdr.de>; Fri,  5 Jun 2020 05:38:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726088AbgFEDis (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 Jun 2020 23:38:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726076AbgFEDis (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 Jun 2020 23:38:48 -0400
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E082CC08C5C0
        for <io-uring@vger.kernel.org>; Thu,  4 Jun 2020 20:38:46 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id v11so8232293ilh.1
        for <io-uring@vger.kernel.org>; Thu, 04 Jun 2020 20:38:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=p0sq3VwpmJiDIuK+Iw7tU5bT3nYTbf1ISfHzs/Afbis=;
        b=qYaATMerMugqRvUcKXrueA1CKhYpEQr9oZ/YIq1AnsjwFrB5vGmz2vyOPb666slwTD
         Fv90FlmcS49PWR2wAnMDvLI91IQUfBA1bmV1Ga3mN6+UEZjMvqJ5WD0RqJazRLGz21FD
         9YxV2NbRWknNhLiU+EGqDfiSzj1PRl6ElNR+oIq/j7WI2r6cL3D9HiQAmXZvKhEgEyXm
         S9uXdUKYVyZ0N2+ZNxD6LOKJSnwZl7TTLvxPDoXR6cElb1YhLY4PeSW/neI+/iLtBqCv
         BuoSs3jXSTs5ga49FoE61g8hBxSSJ75Q5TlLqpPp2hCBGukp6LbP0Dix5t+s+KZ3ZJ6h
         vZnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=p0sq3VwpmJiDIuK+Iw7tU5bT3nYTbf1ISfHzs/Afbis=;
        b=D1AoQuf4efOBG2U+fZngJjJ1Dq8y54xsXkH3u7A4yFhSgSrGwVpLJMK2x4LWuXhvcB
         n6XXyqQnSojKeR81aAgUNl2bE+wSHoboY8DDcaEpYsiWvJ5GK89Txmel+YV1wZzVKSaw
         y9vYmtMoTTMN8p97lwKc6nHknYiu14zJj1cYKAuTQbDSReK5LXg1CCA4H1sp7dR8vCCd
         eCebZ5o6p00yU+SksXAOHtcKT2QWVnhUcILlAGu3S8k8m8MCbEMkCBWhIe0UxNWdx9Ha
         GzEkLpm+9uJLbCKi66klF4E76maW2UrHYDviWS2FKA3EJtCYtIieMp+4HZ6YJpTOrzH8
         6MrQ==
X-Gm-Message-State: AOAM530W5ineSvFgUqOcMjcYLl36DMksZc1iLg5vb5gxCuc6Arv79Elk
        Bo/QNswTyTTGXFWsPDLeoGxoCs7nmBDgifFHSkQ+VFgP
X-Google-Smtp-Source: ABdhPJxtVnw0ko1RQQJ4PPiVyqbXd32roxG9uzaTkvBppP1FBcdiZ9wC/XCt3XtJ6F6ti6vq58fct5uGPTk3Lmff4Os=
X-Received: by 2002:a92:cf52:: with SMTP id c18mr6854598ilr.142.1591328325677;
 Thu, 04 Jun 2020 20:38:45 -0700 (PDT)
MIME-Version: 1.0
From:   =?UTF-8?B?6ZmI5LqR5pif?= <chen.yack@gmail.com>
Date:   Fri, 5 Jun 2020 11:38:35 +0800
Message-ID: <CAP6wFtSZ1LOWsb=nXwnPGdcAWvpvwdHo_SUuMpnAcqbBdtfFRA@mail.gmail.com>
Subject: support suspend/resume SQPOLL on inflight io-uring instance
To:     axboe@kernel.dk
Cc:     io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io-uring instance can be set flag : IO_URING_SETUP_SQPOLL to enable
kernel thread polling SQ. but some application have random io
behavior, for example:
     a). a burst read/write for a while,
     b). then many scatter small io operations.

during a) period, use sqpoll will be beneficial to performance.
but during b) period, use sqpoll will waste cpu time for empty busy poll.

If we can have a method to tell kernel start/stop poll sq when we
need, it is good for both of a) and b):
     in a) period, io_uring_enter tell kernel. start to poll
     after a) , io_uring_enter tell kernel stop polling and.
