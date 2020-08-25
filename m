Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 239DB250CBD
	for <lists+io-uring@lfdr.de>; Tue, 25 Aug 2020 02:08:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726041AbgHYAIp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Aug 2020 20:08:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726090AbgHYAIo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Aug 2020 20:08:44 -0400
Received: from mail-vs1-xe2c.google.com (mail-vs1-xe2c.google.com [IPv6:2607:f8b0:4864:20::e2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1817EC061574
        for <io-uring@vger.kernel.org>; Mon, 24 Aug 2020 17:08:44 -0700 (PDT)
Received: by mail-vs1-xe2c.google.com with SMTP id a13so5420530vso.12
        for <io-uring@vger.kernel.org>; Mon, 24 Aug 2020 17:08:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=twosixlabs-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:from:date:message-id:subject:to;
        bh=cOZLPbGdSS30S8EDu1lXsLlW25UDxWTiobWQ6RmxJwk=;
        b=HVGMA6GLPK/I4ofPVxL59hPANBrFoWGlzuNQ+7l9fx2JSuS4slkwa4fCYlKAVZ9Xn8
         praCe2bWS7nFPZwFsJibzXKuuKfGfFJB2Ppa2voVjGOooSkinZPqIMt9bn75pBUSPaDk
         OBV83R0YjusXqHVogmJb4LqqDstOuY/h2Zo3szidRj5diSkpCTaWzszLv796pzorX8xJ
         6UM/saD4eyBab8trX6pNyxK33jky71pOR5IA7g5+UP+dNr+a8rHHD+g9dl8kiq9sJ8UJ
         fM1i6DkZU5gr5AOZlhD5ejTxaNYP0gcqFRBA+3g6gTHwFhOvxgDMVH6ZdeXNvG//ZCMJ
         niXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=cOZLPbGdSS30S8EDu1lXsLlW25UDxWTiobWQ6RmxJwk=;
        b=KNFOuY6GIdE5a7JSf02f8aSyCUbzKF8gw8gLGF3kz8/t5EV5hxNOkKJSQlANXa+9Cb
         i2nIfKRqtIWkgKrT1t+TjJibuilaVJ+ONTbW4llE+1c2GMe69j3e2dVrQdbUZuraQx0h
         ZIh8+PjPNhXNSUHTLR/mV6hNrUb0/oPYmnvKkrDkLigWoQQlRdOGH5TZlurfZWdHkYuD
         Lx0zRzDtrunFQY0QgdjA2K5aCVzJG3/UYC3ATmVue5x/Hq9E4Q2je+ppWbeTg8Q3fCrE
         qwEjwWJviqcHoHfmKem4OWoZlnkPLn88BA8CSSIE72+670mnR2+Qo/rUBe3ND42OWz/r
         KDFg==
X-Gm-Message-State: AOAM533a5+juvknPOlrVIR5CpFewIH78u72Ikd7/LAB/drqYEHf8uxkZ
        e3aSpVwa6Twr4GtnBi4WLlPLRTMt3+/a1+zxQlk/h5byIhviJBsj
X-Google-Smtp-Source: ABdhPJx0+iLjvmjMIYIdcshVTL6niOSM5ILmT0HCBlm9TyuiqhkKJlIxvEfL2J+3wCJO3hYL5ub1VmHYppWvvVDrGXs=
X-Received: by 2002:a67:f44d:: with SMTP id r13mr4581257vsn.184.1598314122754;
 Mon, 24 Aug 2020 17:08:42 -0700 (PDT)
MIME-Version: 1.0
From:   Michael Spiegel <michael.spiegel@twosixlabs.com>
Date:   Mon, 24 Aug 2020 20:08:32 -0400
Message-ID: <CAKm_-fgeS=-pQJs3ZO0Kju-r2piO39Xnt-CtWoicfOe0a4SF8A@mail.gmail.com>
Subject: unix pipe example?
To:     io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

Is there an example of using io-uring or liburing to implement a unix
pipe, if such an example even makes sense? One consumer process and
one producer process, not forked from a common parent. I tried
searching for an implementation online but couldn't find it. I started
writing an implementation myself using liburing and using a unix
domain socket to share the ring_fd. But it seemed like the
io_uring_params also needed to be shared across the processes? Looking
through the mailing list archives there is some mention of wiring up
io_uring support for pipe2 in the future, which is equivalent to what
I am looking for.

--Michael
