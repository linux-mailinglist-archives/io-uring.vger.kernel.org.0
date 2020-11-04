Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EB6B2A628D
	for <lists+io-uring@lfdr.de>; Wed,  4 Nov 2020 11:52:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729243AbgKDKvp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 4 Nov 2020 05:51:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728066AbgKDKvo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 4 Nov 2020 05:51:44 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 138D7C0613D3
        for <io-uring@vger.kernel.org>; Wed,  4 Nov 2020 02:51:44 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id 7so29140024ejm.0
        for <io-uring@vger.kernel.org>; Wed, 04 Nov 2020 02:51:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=confluent.io; s=google;
        h=mime-version:from:date:message-id:subject:to;
        bh=QtNh8OOdoOFqPyUKGun7lYeu0GcuZ8u5E0Qpqh5hkfo=;
        b=BYOAuZWaDqi3DeVswGeCbpCsFeSlwukhV3/IsGqFsf15sgrodVoQJdFnQpZVLgf8sw
         cddtTT1yVGNYTi4SLOYrGiQl4OcaN1t7q71rEjdGIObbtxqZgrJMCYgkQB3XftIQIoS8
         br2YhqSL+dnj9qpfHPyoL0otbHjGZtEFb5D9gDJh3zFoqWO//tIrpbxOx46zjdiJx5ya
         JVo2oEqko7nlllxXQ+ofarzQX87uKWJ3LYQXwKYv1Yw+SJL3UJ5SJ9YO5TUn3BkM3R8d
         o8CWBTbmXD64loWWRHeY4KbXwbNrwGxbWt4PXEaXs3jIANsCyCMEY1oGEBNw8AclXqJJ
         P1bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=QtNh8OOdoOFqPyUKGun7lYeu0GcuZ8u5E0Qpqh5hkfo=;
        b=Q2x2Qvuh0AyhqgQ/dVJ5hWC4T56jkGxeDeHgdE1ynXibeN5fqmotRzv2Rcac7Vi9aS
         gTyDtme8fwNLEpI8UGf55t+toXQ8QNhqGIPPVvuFDa5LtDGT/99vo8o5foAPyoHzflb1
         bwHJdQ/gx8mF4LW0N/MgCdfq2kNN3ZbKVX1E+vuUv8ATl5JHLIVHl/V8RW66ASxOgGf6
         hEJd+kxywGW69VYZhISUWW0ulePLUTknnKdPuBpaaRZS+OpAXZKYffUNkSuMyTL/x23p
         boYW+T1zwMnVktyQGwj0wh0+fy8VxOz6dBDN46CjaLgOMRkFKZJVnpMkbZOWqi3Og7nW
         6kZQ==
X-Gm-Message-State: AOAM531Cby3tpCmWaKVxdkrHOYaKEKggfYrWCEgdwtcOEfTEj+470nkx
        DBx6OMaTfom2PjFV+VQ+Id1dR4fp9uNR/riMKXxp6rSlOVOcV2Jo
X-Google-Smtp-Source: ABdhPJxhzdfGlaNtHuRhKg2/iOGnj7hsIE5gEg+tNfjsXh9trtjzUUuweAQ1OFo/st6Rs3KtElF+P8myxqHyq5js00A=
X-Received: by 2002:a17:906:2697:: with SMTP id t23mr413044ejc.292.1604487102460;
 Wed, 04 Nov 2020 02:51:42 -0800 (PST)
MIME-Version: 1.0
From:   Tim Fox <tfox@confluent.io>
Date:   Wed, 4 Nov 2020 10:51:32 +0000
Message-ID: <CAMkGPyK=9bztK-2Ckg-2pOUhxugzXO=0-KGH4NL6+KQFnq7vBg@mail.gmail.com>
Subject: Support for random access file reads
To:     io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello folks,

I am new to io-uring and would like to read bytes from a specific
position in a file. I was looking for some kind of pread/preadv
functionality in io-uring but couldn't see any.

Perhaps the expectation that the file descriptor offset is explicitly
set via lseek outside of io-uring, to enable random file access use
cases like mine?

Thanks
