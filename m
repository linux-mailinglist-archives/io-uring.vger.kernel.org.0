Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18331365E03
	for <lists+io-uring@lfdr.de>; Tue, 20 Apr 2021 18:59:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233103AbhDTRAF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 20 Apr 2021 13:00:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233141AbhDTRAE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 20 Apr 2021 13:00:04 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FFF8C06174A
        for <io-uring@vger.kernel.org>; Tue, 20 Apr 2021 09:59:33 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id n127so8820453wmb.5
        for <io-uring@vger.kernel.org>; Tue, 20 Apr 2021 09:59:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=reE9tUJogarS5NvJyxlLcfwgilzQVWwQORQb0nYfXac=;
        b=cLRHS04JbEHO9ku5vZU0LhSBbWf+GdX0tOucx6NGPinnYcztBJZXd+y/LWWKVfWFNa
         VwmnIlPvSrVBZ/LF7ts1RKWR8XFgNEd9NmAtOLufpvyIVQDMCv6waCIma65Hop+NuL4g
         AKUYt/9nvAQTrJU9XcdrWf+Y2A5HpyYgD5C7n8aBOaamBmdOHjEWWF6/0/UDDlcpQRiX
         h7HNZttFyVsop1kmpEmQRanXsFDJOQu6sL7bIaPnq+YAqCT0I86E0wjZx7ygvLCnD0W1
         9uO8qCRH+ESO0XpwSNzih0qs0b9c6s4b/2r1nWKPYzEi2t3dwTCUbyAiC0x2aCxnV1EI
         Ax/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=reE9tUJogarS5NvJyxlLcfwgilzQVWwQORQb0nYfXac=;
        b=L0+BoalhP+71mWNJ4lDxOvQhLPoUwmaaW9JfsU2cZYvMyTMD4jEH6Oi1nGSGZmOM7h
         L4qOKRMzhBTOGqP6Jlw3np3FsyyiAkfKNkKY1yPZW1EeT/GRdKOYxteV6S+k3gr7eYm9
         I2HRsqZ4Ahk2vmw2+YKK7b6Cn5bC/VEjC+Z9UgZNtKWIOEB7iw9r0x1btH3+IlPd7/YT
         PMWCexCtP7C+E9FEB/NrpjtzqU0vrQ5lqeMlGZ1Z/I6QPtW9/N0R4+O9THuIeWrpu9Jw
         JM7rAonKxUSGnLPEYpWSNvsda915EAAGokrGSdpmarh+ci6sTVaO+qL+oiyoKvvzm16+
         NBxA==
X-Gm-Message-State: AOAM531ZueqSzbdZKg94Ww5GBJkl8/ToqyBlTIN4+hIRpqt5hr6sM4ZY
        riQ8wFHfWb4RYpkuU/18OwuPQzh5DVNwvw==
X-Google-Smtp-Source: ABdhPJyoV7EjetC+2onX8qJfjftEy1RG/L+et6KFcE8/uo5NxAm4t97CLMDKHiFxJaSpXOz2WdL+0Q==
X-Received: by 2002:a1c:4d08:: with SMTP id o8mr5413601wmh.57.1618937971876;
        Tue, 20 Apr 2021 09:59:31 -0700 (PDT)
Received: from [192.168.8.197] ([85.255.232.116])
        by smtp.gmail.com with ESMTPSA id g132sm3872532wmg.42.2021.04.20.09.59.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Apr 2021 09:59:31 -0700 (PDT)
Subject: Re: Emulating epoll
To:     Jesse Hughes <jesse@eqalpha.com>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
Cc:     John <john@eqalpha.com>
References: <YTBPR01MB2798B37324ED46A33DCD21B0BF489@YTBPR01MB2798.CANPRD01.PROD.OUTLOOK.COM>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <98e1c6bb-1706-e1b3-b7f1-c5418ee880be@gmail.com>
Date:   Tue, 20 Apr 2021 17:59:29 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <YTBPR01MB2798B37324ED46A33DCD21B0BF489@YTBPR01MB2798.CANPRD01.PROD.OUTLOOK.COM>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/20/21 5:37 PM, Jesse Hughes wrote:
> Hello,
> 
> I want to start by saying thank-you for working on io_uring.  My experience using it thus far has been great.
> 
> I'm working on an open-source database product (KeyDB, a multi-threaded redis fork) and we're considering rewriting our IO to use io_uring.  Our current implementation uses epoll, and processes IO on (mainly) sockets as they become ready.

Wonderful, always interesting to learn about emerging use cases
and new apps using it.

> 
> If I'm understanding the literature correctly, to emulate epoll, we should be able to set up a uring, put in a read sqe for each incoming socket connection, then (using liburing) call io_uring_wait_sqe​.  Correct?  Is there a better way of doing that?

In general, the best way to do I/O is to issue a read/write/etc. sqe
directly as you've mentioned. io_uring will take care of doing polling
internally or finding a better way to execute it.

However, to simply emulate epoll IORING_OP_POLL_ADD requests can be
used There is support for multi-shot poll requests, which Jens added
for coming linux 5.13

> 
> Our end-goal is not to emulate epoll, but that seems like the quickest way of getting something working that we can do further experiments with.
> 
> For reference, if anyone's interested, our source repo is at : https://github.com/EQ-Alpha/KeyDB

-- 
Pavel Begunkov
