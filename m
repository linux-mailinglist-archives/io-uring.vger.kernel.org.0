Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93C2239749D
	for <lists+io-uring@lfdr.de>; Tue,  1 Jun 2021 15:50:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233924AbhFANwN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 1 Jun 2021 09:52:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233797AbhFANwM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 1 Jun 2021 09:52:12 -0400
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 892AEC061574
        for <io-uring@vger.kernel.org>; Tue,  1 Jun 2021 06:50:30 -0700 (PDT)
Received: by mail-ot1-x32e.google.com with SMTP id x41-20020a05683040a9b02903b37841177eso4682400ott.9
        for <io-uring@vger.kernel.org>; Tue, 01 Jun 2021 06:50:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1vQtzRreX0HX5KSFZqbjilcBacZkOFeexZMD6JBQZxU=;
        b=zORW36yg5Fimy6Ksfa2UniC+/06Xyywgdcfcr716cCOdT7mZKoa7NQJjBjuwEWiJ6T
         KEXfZyZwDNBQVaHhNy3CuxZxFaRyv/1tv8oGdC1LSmtTVLibeOyxqDImYUOKBzuYOuyM
         ZKQdISUxK0sOHy1gLgUwXRb4XNa/kwne8fOe9Mdom6fr3qkApn+AHGO5uRIQnQeSUawM
         rcCVRuoBUQ6M12+yxWrtPpbIIWGM1Wjs7Ik/8s+9qYX2DTsg9K6PhMwMt5x0qZUh3Xs4
         COaxM+iX4zSKSrahhZhaEhI907TTWO5pURqlUyWsllwa2KFuzNFe6JbB+ZKb//tts92t
         UytA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1vQtzRreX0HX5KSFZqbjilcBacZkOFeexZMD6JBQZxU=;
        b=mi1hTUFDLDDjLx3Me/yAKXpYdSlcUHqBqlcew77zPArYI+XD3Nk5TtouRAPwL1YbUy
         AySGDQ32c1nF7THm90LxRd/rSxTLqSyZgqB2YCVg496vip3BisY5JXJ5nFynxrNm3aF6
         3WjJjs4WemxQsKunZfWgE3Nc3GFUXDdLdMOmzf/lYp1CQfGFNVvnr9T8Y0EJ90DzOyap
         yf1JNM6DG5Q+/bTS7XQpncRMMdKDpczkUJ8C2TrBNXp0P5+nJYrbTugLaynEdI5/cXVZ
         LomISQ2EV9bj11NIjOQDSMZQPpWBcsanwgOeeLDsq0R9yINLHApb3Q2vIYTLELcL92b9
         lEyA==
X-Gm-Message-State: AOAM531BZB4q2quiQw/THh+YuJBsa2Z81mCtLX9J6A2rjBi/PetMm47Y
        jzYEZMajPJhiKrcwihekSA0ccA==
X-Google-Smtp-Source: ABdhPJweRrooZTzlOrvUdExfXI6KxSyefokIsqgAyx9SYEe4pd/G6RDa5aO/xHUK2Sz2dthBlEPwbA==
X-Received: by 2002:a05:6830:12d6:: with SMTP id a22mr22318356otq.66.1622555429870;
        Tue, 01 Jun 2021 06:50:29 -0700 (PDT)
Received: from [192.168.1.134] ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id g24sm1591324otp.17.2021.06.01.06.50.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Jun 2021 06:50:29 -0700 (PDT)
Subject: Re: [PATCH] clarify an edge case of IORING_SETUP_SQ_AFF
To:     Hao Xu <haoxu@linux.alibaba.com>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
References: <1622517099-197667-1-git-send-email-haoxu@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <c3661a84-324c-cd13-2a45-419c6eb77dc0@kernel.dk>
Date:   Tue, 1 Jun 2021 07:50:31 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1622517099-197667-1-git-send-email-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/31/21 9:11 PM, Hao Xu wrote:
> A container may offen be migrated to different cpu set which causes the
> bounded cpu set of sqthread being changed as well. This may not be as
> users expected, clarify this situation in man page.

Applied, thanks.

-- 
Jens Axboe

