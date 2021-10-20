Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B930434CFA
	for <lists+io-uring@lfdr.de>; Wed, 20 Oct 2021 16:02:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230073AbhJTOFF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 20 Oct 2021 10:05:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230155AbhJTOFF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 20 Oct 2021 10:05:05 -0400
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3B23C06161C
        for <io-uring@vger.kernel.org>; Wed, 20 Oct 2021 07:02:50 -0700 (PDT)
Received: by mail-ot1-x336.google.com with SMTP id y15-20020a9d460f000000b0055337e17a55so890686ote.10
        for <io-uring@vger.kernel.org>; Wed, 20 Oct 2021 07:02:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lDqH2jUk9gpO3lmRRDRBqbmD26jEPR69skrcQuuIqmk=;
        b=t2djaRphM71qBUm91JfwhfeYSz+3Q+ablSn5dDN5v4PisUMlzowKx0xHYIYaWd2fRi
         XNDXRDcH+Rg1KFeM1hcMS24utEtk0+gdUrt62iSzFIYbLuq/vEUb/GSUSFU5XAFafNng
         ItcQxBMuY52cXB5k/7E/lNq6oT12vL2K/zNas791ZSzNzRA4dde0KYRHOiL19uyFze+Y
         8KKJS9gt9up1i8tRZK7Ow+QM29FGmY5sz8skdm/+OpI3q0xLNtKkRG9WLmVFxSCrOt6v
         QUynbYMrkUOEurm7BQ3D5obyEOuVTeLVfXjRBQNv/0A12X37qKgXSNCBb3qNPPwLmGOF
         1MCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lDqH2jUk9gpO3lmRRDRBqbmD26jEPR69skrcQuuIqmk=;
        b=PTa73pGyeE5wGRf44KjNWokJXESVr4xqvzVvZkh3az299Pjd+Tww6E4EKxs2jBO1Ay
         +wqnjIuYd5Ge2/rduHATi58QmIzPJIIyU0Ucb9AmM6kYVWccSLH2NHhJmJP7WidAiU4c
         knNReQZQ5C6tTrqCr7t6PTRlt5XLtpS67VfFFK/vnkfrO9EqpUO0DZHhuKxSUP8KzznG
         blj7hZkgwtUv2Xj32blbBdumYJe+bz4jggdDLup9Ws+Ha0/o18Q2yiR4BrZpcwALKqXO
         5EdmGminkuyPXS9KbNz1iOuMerWuLwV1MifTsYsqnRJYWt2dJvN2ugiuGN400zHiKPZ2
         PsgA==
X-Gm-Message-State: AOAM531DPmTb/Cskp1Z04xilAO8Tw4yfg1VMpSXHK5uvoN5B6H+qq+Tq
        Kq542bJ/DYhzY6aQoS61iji2FA==
X-Google-Smtp-Source: ABdhPJx4cWu2P//XiYfbWLSIEMz8tbikXeNb2PRTVrKyCMlvUVQ4KtZk/remA8V88hHEJC+fQaTHrA==
X-Received: by 2002:a05:6830:308c:: with SMTP id f12mr32432ots.15.1634738570136;
        Wed, 20 Oct 2021 07:02:50 -0700 (PDT)
Received: from p1.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id e22sm489662otp.0.2021.10.20.07.02.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 07:02:49 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     cgel.zte@gmail.com
Cc:     Jens Axboe <axboe@kernel.dk>,
        Changcheng Deng <deng.changcheng@zte.com.cn>,
        io-uring@vger.kernel.org, Zeal Robot <zealci@zte.com.cn>,
        asml.silence@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] io_uring: Use ERR_CAST() instead of ERR_PTR(PTR_ERR())
Date:   Wed, 20 Oct 2021 08:02:46 -0600
Message-Id: <163473856398.730876.13037999645192762534.b4-ty@kernel.dk>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211020084948.1038420-1-deng.changcheng@zte.com.cn>
References: <20211020084948.1038420-1-deng.changcheng@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, 20 Oct 2021 08:49:48 +0000, cgel.zte@gmail.com wrote:
> From: Changcheng Deng <deng.changcheng@zte.com.cn>
> 
> Use ERR_CAST() instead of ERR_PTR(PTR_ERR()).
> This makes it more readable and also fix this warning detected by
> err_cast.cocci:
> ./fs/io_uring.c: WARNING: 3208: 11-18: ERR_CAST can be used with buf
> 
> [...]

Applied, thanks!

[1/1] io_uring: Use ERR_CAST() instead of ERR_PTR(PTR_ERR())
      commit: 898df2447b9ee8d759e85d33087505d3905bf2f0

Best regards,
-- 
Jens Axboe


