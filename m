Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06B112411E1
	for <lists+io-uring@lfdr.de>; Mon, 10 Aug 2020 22:45:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726531AbgHJUpT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 10 Aug 2020 16:45:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726474AbgHJUpS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 10 Aug 2020 16:45:18 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E860C061788
        for <io-uring@vger.kernel.org>; Mon, 10 Aug 2020 13:45:18 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id u20so6371342pfn.0
        for <io-uring@vger.kernel.org>; Mon, 10 Aug 2020 13:45:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=bSPnxn3kyrwVbRID2Yxgnq1PnNVuxdGlfum9Ij0n2vw=;
        b=a8927blXkuuZ77vcJAPIc1fCrs3Z/XvpAT5yK/HJZMyDdd6sPzS44TtPc9CZmzVzgW
         tmYNMFKu3pmkvywv+sYJF46Mo+op2XhIwM/AqPfTWYskr6N0/0njCZ1t55ced7+wZnld
         bmDr8++wf0/rdkT2od5ARNoaV3e/P0ctYt7QqqSNtSSmSddNLSdalBUS7yX5ytRqQTNl
         09G6532ra5wArLu/htXZqbyjCFRy4Xr5PJLQC+8EipSuzPQttCS+jXputk+kAi3Wvgl+
         OdF645lAAl/TnSHN5z0O4AW9D1VsKtvcSrdKOk1nO4akJq7uMajQf6TiApC/XcP4Gmq+
         KhDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bSPnxn3kyrwVbRID2Yxgnq1PnNVuxdGlfum9Ij0n2vw=;
        b=nxaNH/DPKjRo2Zfy8djwHgXs335dfIrVKnphH1a9+2T+FkPHgQxgamSyCmTdKcwu7o
         tAuAIRja/LEr2Le2F0r/2Cysx49yZcOuSvzwsOsqJHBrZwrGo6d1hmJQncDi1x/1h3JQ
         hSHoaVvdOYpv1i71lr6dJu0RHdA5XDJp6AJXhwzDXlm6h3CpclhcbGvNptSzpuCAVa8F
         5yJgRD5ON7Z/TmvNb08dIPGxpGD4uQluTJfBE86wSt+OGhPYWXPGWJxf0XjOqJJXscyh
         6o+lvw+knqPlBO7kyvWeGA95uF2fj1ZsaLIizfnpRBYXxqQSLFN481N+Z2/7uJalURqo
         yHrQ==
X-Gm-Message-State: AOAM532Wk9PZX5+dbgmOyjemj6f7rhXp0jdcRsHQEJHVqu7gyDgC54CX
        PsW6/y4GLBLkXnPHiiksVy2G0Q==
X-Google-Smtp-Source: ABdhPJxKiSSq6UWiaNnF1Pac7zVqzamjjJOvuEPwlk6vbhwUi47n/I0zTu2dbu7uhLcKtBTPOAFBLQ==
X-Received: by 2002:a63:b0a:: with SMTP id 10mr23515903pgl.166.1597092317352;
        Mon, 10 Aug 2020 13:45:17 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id d1sm397055pjs.17.2020.08.10.13.45.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Aug 2020 13:45:16 -0700 (PDT)
Subject: Re: INFO: task can't die in io_uring_flush
To:     syzbot <syzbot+6d70b15b0d106c3450c5@syzkaller.appspotmail.com>,
        io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        viro@zeniv.linux.org.uk
References: <000000000000991ae405ac8beb12@google.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <d458ed96-32f9-edce-a8b1-e9941c6a8ef5@kernel.dk>
Date:   Mon, 10 Aug 2020 14:45:14 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <000000000000991ae405ac8beb12@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

#syz dup: INFO: task hung in io_uring_flush

-- 
Jens Axboe

