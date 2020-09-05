Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22EF025EB26
	for <lists+io-uring@lfdr.de>; Sat,  5 Sep 2020 23:59:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728257AbgIEV7A (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 5 Sep 2020 17:59:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728103AbgIEV67 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 5 Sep 2020 17:58:59 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F99CC061244
        for <io-uring@vger.kernel.org>; Sat,  5 Sep 2020 14:58:59 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id v15so6151210pgh.6
        for <io-uring@vger.kernel.org>; Sat, 05 Sep 2020 14:58:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=Uf9V0JznqswddJGc8rrf+pAyXDRkpGKbUcaFIT0uMdU=;
        b=a3Ap6b6FdVvbQgRsCMgS0mKx8J97sDTGlH1iJYiv6JqvjuoPNLsfp4Byh0090zp6Yn
         00adFJ3OJs4Kv2fSBOoCDudumCGehzgahDz8nrH4eo5Kg3MzHiIe79HLONabkgLKagAG
         PpBMPaFNnhbowNwrg+PPkHbdV/ONXsk/Et381g4wiMBozZKlMC+Ctr/KbGJ4GK5V+Ih8
         wS4unLJBLl3IEjAsr1OLpfBaHrvaQuQTuAdQ3B2W80eGuptLUxpvFg9vr1u6feJWPQ8Q
         hMFLcmVzeVdhdUOMeVnmv0U+f8+YAEd4lNchwPRn4frPsI8XNtLFMR10edYFYlunmKsO
         lkEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Uf9V0JznqswddJGc8rrf+pAyXDRkpGKbUcaFIT0uMdU=;
        b=rulG6x8UyKW8DsMv5dEj/CR0f+WLNarDOF773XG4kJmQf3IjMTYjX8icRrYPwx4Chc
         Nm+RuDLHe+hx8lKTSW2ND777Xjasrpv3lXw7hXxLcexNS3oW3IDAHFiqCeIKep2cB7KJ
         OjxRGem+P8acA0d6C2ZlguaBHQnUkPDKbwRC3R0KnKkpqUA3BKplEOCnnCJFfHrhgNyn
         4xf8SOmZ+9KVqwO53QoWMmM9mRJI5tPHd6nvAyTYm/5+m13mTEkcd2wxF37ekujsM+Ft
         BGdmxRfktcqID9Wiiz4On8TSv38eB8KP2B9tNmByVcvyhtm+ZmXJrEgfPO5ixgdjkOk9
         2V0g==
X-Gm-Message-State: AOAM533U8x5HCWKg+bhvBHKyJmIFwRQ3R/oi/qceaoCPkzw5Wsec5ca3
        nFWJmnQ7GRzuhVn8GegnA2IUbkfY6+IIq83y
X-Google-Smtp-Source: ABdhPJz4hcIsEndcIYrFw8oBpU0QY4OofknVVrdJVw5vwyOvVtl7U/e9O/IlHjKlU1JNi3u4tM7VqQ==
X-Received: by 2002:a62:f904:: with SMTP id o4mr13887240pfh.14.1599343138245;
        Sat, 05 Sep 2020 14:58:58 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id a26sm10412596pfn.93.2020.09.05.14.58.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 05 Sep 2020 14:58:57 -0700 (PDT)
Subject: Re: [PATCH 0/4] iov remapping hardening
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1599341028.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <8381061c-e2e8-6550-9537-2d3f7a759e92@kernel.dk>
Date:   Sat, 5 Sep 2020 15:58:56 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1599341028.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/5/20 3:45 PM, Pavel Begunkov wrote:
> This cleans bits around iov remapping. The patches were initially
> for-5.9, but if you want it for 5.10 let me know, I'll rebase.

Yeah let's aim these for 5.10 - look fine to me, but would rather avoid
any extra churn if at all possible.

-- 
Jens Axboe

