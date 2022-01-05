Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44375485931
	for <lists+io-uring@lfdr.de>; Wed,  5 Jan 2022 20:32:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243541AbiAETcd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 5 Jan 2022 14:32:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231584AbiAETca (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 5 Jan 2022 14:32:30 -0500
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D112C061245
        for <io-uring@vger.kernel.org>; Wed,  5 Jan 2022 11:32:30 -0800 (PST)
Received: by mail-il1-x133.google.com with SMTP id o1so181792ilo.6
        for <io-uring@vger.kernel.org>; Wed, 05 Jan 2022 11:32:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=qpCxtfwyVwBIee1PBexn3Z3InR/064lKrv4gYmq0iEg=;
        b=W7u+wiQHn79Ti242OgCMKDUwuBUEcwO3WrLpyVELKVQUsGM02xzlhOmH4Btz8Zo6XU
         lxvQwfPs96IbaCkCFCq61GpwsM4uT2Jq0eYYXWUaC63yRStHgClTP8WQF/wfaiGtsxlB
         k8z5Y0VaoVZCD295+pgtNGIfOi4dPaYrpBkpVFaUKklOh3X6JG0W6gXO/x0JPmArQMG4
         MPEFjPZv0bSmXr0RYA43pW817W0TCRh3WwN/qwPgW3EH3gYQTp+1s6jiavkCZA/u0v2a
         MXSxzhTEZ0i8viw+qytehIKE/7osM1ESsiPhO9AvDqS2UDo9Eas8lMU8o3JLlcllQ92k
         d05w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=qpCxtfwyVwBIee1PBexn3Z3InR/064lKrv4gYmq0iEg=;
        b=HZ49Gfn65EhNvzeNTVMohkaU1M+uUlu5Znj/t0FXIErWOHz7PnDEVlqQ+od4uJjGz0
         nKFVdiO+RGvmqzJ9oRwT5//2IRaE6g74XouuqKAYS56/M+oCzHiir98sp7b25JYt4cd6
         b+ryU7eb8FH646DQFXRzWkyoQiZbAMiUrr6YuuZdyHgVOWk79hv9SUWF5UHzzBPjPWbW
         67pD+6kch4g+T0R6Aghmb6LXO96jHZx3L06faB+phCpSfhnE60eJfgtlrAc8AT68IxWW
         VNRTjE75JCjjtL2tK4mWaz3YqXd3mKw4HoemHiVWVoVtTx2EN5OQLWNOh/GNwU41NvtW
         hMVQ==
X-Gm-Message-State: AOAM533fPwub/MO9f5cnR3h9tuWeWHtGM39mRVN099oH2/8HP/KGWWnI
        ILOwkdDgnlxAgWqGySP0THyoCA==
X-Google-Smtp-Source: ABdhPJwFb3zv4DUiGeu9ejxwMSGKd4PB3tS78fU79SVD8P7c1pBDEfYPEx9omtq3DFe8IXXA6+V74Q==
X-Received: by 2002:a92:c510:: with SMTP id r16mr1237447ilg.74.1641411149774;
        Wed, 05 Jan 2022 11:32:29 -0800 (PST)
Received: from x1.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id 7sm27406883ilq.23.2022.01.05.11.32.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jan 2022 11:32:29 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     GuoYong Zheng <zhenggy@chinatelecom.cn>, asml.silence@gmail.com
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1641377585-1891-1-git-send-email-zhenggy@chinatelecom.cn>
References: <1641377585-1891-1-git-send-email-zhenggy@chinatelecom.cn>
Subject: Re: [PATCH] io_uring: remove redundant tap space
Message-Id: <164141114909.317320.15522175308443944192.b4-ty@kernel.dk>
Date:   Wed, 05 Jan 2022 12:32:29 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, 5 Jan 2022 18:13:05 +0800, GuoYong Zheng wrote:
> When show fdinfo, SqMask follow two tap space, Inconsistent with
> other paras, remove one.
> 
> 

Applied, thanks!

[1/1] io_uring: remove redundant tap space
      commit: c0235652ee5194fc75926daa580817e63ceb37ab

Best regards,
-- 
Jens Axboe


