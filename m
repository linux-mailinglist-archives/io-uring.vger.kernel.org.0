Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51E061DBAE8
	for <lists+io-uring@lfdr.de>; Wed, 20 May 2020 19:14:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726737AbgETRO4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 20 May 2020 13:14:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726697AbgETROz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 20 May 2020 13:14:55 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88A2BC061A0F
        for <io-uring@vger.kernel.org>; Wed, 20 May 2020 10:14:55 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id f4so1724536pgi.10
        for <io-uring@vger.kernel.org>; Wed, 20 May 2020 10:14:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dn1wLG2S34dD5g+JaUALnTVvVDB4i9x8X9j9vbjn1mQ=;
        b=eYRaTbLg32v2n4LboXQ7BpLYdJHHgJjmtDERcQzxYAE46+NrISJKRTNSeONXsRVLc8
         41c8t0oyF+Br6sTOM1my9WzJulOPR6kTy6bMLMlWCDlWWOHUMOxb1oQw0SiDdLNbJKL2
         ZPE16C8urAfkDoxV4ZqLZ5JdCzNdnQwJzP9RpQPQU5sFbz+I73z9NWU8MN4p55XPwUhl
         T5LQxQg9Phroeg5QalUHtc04iC6NfVwIJGUQyKqx8MHQg4hvovZ+CCck9QAGx5Iifaeb
         fSHCvu05t4TbJr8kbvpERmKSOefq93O458vMZlPowaso+bBw9sr1bMGIXKsjyTS4JyBy
         HKrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dn1wLG2S34dD5g+JaUALnTVvVDB4i9x8X9j9vbjn1mQ=;
        b=AQcq/n2AKRhSjSuDHqqDRbPiB6us58U3ViEkHBremH86WT9S+1fXMnhdbTq+K+4ibR
         Xx0Jv+TMcuWjBhFKYQIBzl3rEazi6aDLT7UEpw7McxHmsodVPphcMO7aarWxcFagFqdq
         7Pf1j6FD8A4Tu8woEYuIL0Gd6de6CiIVkeZGJfmHKJqDe0ewm3l8XpLq+POyav6uyHuc
         wBLffpugX1PkFf1F5tiFF2rsSKTCGvzY+Ee3EJ6bV4Ad/x+nayArxwEYERaHz5C9Rk46
         zCjBzlGx22M8n9kB/niOL8eHpOS4ZB/9jVEPrdYJ4EzkKi0OzS0iCwapKQUr0DKHmdtK
         FEwQ==
X-Gm-Message-State: AOAM531lI2DsTYlaHAfbQQrPz/DOH2LJIv1x7VUzAvSOqne7Q5SdKpbe
        Au6QoKp0m5jFydZ7hSg0jDBQYP/SjMM=
X-Google-Smtp-Source: ABdhPJxsetNXDZAFzwa40fTy5sAqcqTSGbhcYbY6aZ5qPn0ABomlOnOtHeDNfNDBSxnLFRwY+bxGnA==
X-Received: by 2002:aa7:829a:: with SMTP id s26mr1582866pfm.40.1589994894665;
        Wed, 20 May 2020 10:14:54 -0700 (PDT)
Received: from [192.168.86.156] (cpe-75-85-219-51.dc.res.rr.com. [75.85.219.51])
        by smtp.gmail.com with ESMTPSA id d20sm2328183pgl.72.2020.05.20.10.14.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 May 2020 10:14:54 -0700 (PDT)
Subject: Re: [PATCH liburing v2 0/5] liburing: add helpers to enable/disable
 eventfd notifications
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
References: <20200520170714.68156-1-sgarzare@redhat.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <f910cc65-9075-0e54-c4aa-656fb073d626@kernel.dk>
Date:   Wed, 20 May 2020 11:12:39 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200520170714.68156-1-sgarzare@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/20/20 11:07 AM, Stefano Garzarella wrote:
> This series is based on top of a new IORING_CQ_EVENTFD_DISABLED
> flag available in the CQ ring flags.
> 
> I added io_uring_cq_eventfd_enabled() to get the status of eventfd
> notifications, and io_uring_cq_eventfd_toggle() to disable/enabled
> eventfd notifications.
> 
> I updated man pages and I added a eventfd-disable.c test case.
> 
> v1 -> v2:
>   - renamed io_uring_cq_eventfd_toggle()
>   - return EOPNOTSUPP only if we need to change the flag

Applied, thanks.

-- 
Jens Axboe

