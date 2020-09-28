Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9984427B685
	for <lists+io-uring@lfdr.de>; Mon, 28 Sep 2020 22:44:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726814AbgI1Uoo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 28 Sep 2020 16:44:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726811AbgI1Uoo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 28 Sep 2020 16:44:44 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F741C061755
        for <io-uring@vger.kernel.org>; Mon, 28 Sep 2020 13:44:44 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id u19so2602051ion.3
        for <io-uring@vger.kernel.org>; Mon, 28 Sep 2020 13:44:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GKFpSI6C9rAunn1VofSJTIKv2ff2UrX0UL050U/wUXs=;
        b=oOvI+iqeKDHRKueieZsD+GqGys563YFeNrhrhU/tsIxN8UUwtgozIW6hmLTEj24CG6
         9MNvYQtjhUemXtgO/TosN7SM8zQZ+uYO4bboQL6fjfqlAhjz8E1buVkwe52misQFlEck
         nk8ND09fG5oPKxiEukB7gfxX09H+jJuM2xm/v2AC6BtayVa0M1BGzlsxnNjzFrP02fKM
         WUdG7pDKQul70aA9TfjWEje3aHB2BLCPk9eDjKUDLkzDxAUOoQfRoXGQRTMuqs7k40+A
         QaBxp+w2pB6AmKhlvPtDOqUWD8Il2qAJLtKe/kh1EWDY/xZ8oAqSy0OCePuU7bWuazjq
         SZ/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GKFpSI6C9rAunn1VofSJTIKv2ff2UrX0UL050U/wUXs=;
        b=uhGE0Bb2XEzmxZAVIEmqvfqnevplwhTKJtudNwnQMrx6THBJDVxiM0JHi+OAMLacHe
         3ZfCSxVXu9kF3WQRC4uh9YAtjj1wYaPNGo/b7tM3mJyX8aQyoh14jTG9yvwVHK4z0/+Z
         CMq0RHUjN+b3YGneXgmwgCyEeiQh603KVxv23eadMp/FbWdEXYWMRLzC73tmYgsD+Gu7
         9MjZgRzaS2D0wjHSETGk16r/0flSNEnL7fWn3mCyzmqtGOyC+w06V/yYgthBpZSgqxmZ
         BDh6kE0CwVEutbHl+oysFSoOulgzHlESmC3vQcZ6aRJhAfNEBrowz2+hBW2bZxsNwg1M
         ukaQ==
X-Gm-Message-State: AOAM5331qCoI6o5tLkew9PpSDVdNHoX1WH294f6mxv2GRtqEeaK0YgFA
        2QPY23tTnEV/EzrchVdvvUVRXI27E+TJOQ==
X-Google-Smtp-Source: ABdhPJzz9tzvyLYbGtDyA2h4thL7xeh1EZZgzUbTqp+oGac8Y7jP9D3svJ/AaKl4F+UU8MKBHNXGkg==
X-Received: by 2002:a05:6638:25cd:: with SMTP id u13mr381888jat.87.1601325883505;
        Mon, 28 Sep 2020 13:44:43 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id q5sm1175738ile.63.2020.09.28.13.44.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Sep 2020 13:44:42 -0700 (PDT)
Subject: Re: [PATCH liburing] man/io_uring_enter.2: split ERRORS section in
 two sections
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     io-uring@vger.kernel.org
References: <20200918161402.87962-1-sgarzare@redhat.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <9ec4c68b-94dd-a844-dc8a-dcd9ceeae212@kernel.dk>
Date:   Mon, 28 Sep 2020 14:44:42 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200918161402.87962-1-sgarzare@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/18/20 10:14 AM, Stefano Garzarella wrote:
> This patch creates a new 'CQE ERRORS' section to better divide the
> errors returned by the io_uring_enter() system call from those
> returned by the CQE.

Thanks, this is a great start, applied.

-- 
Jens Axboe

