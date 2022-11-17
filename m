Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1D2B62E56B
	for <lists+io-uring@lfdr.de>; Thu, 17 Nov 2022 20:46:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234246AbiKQTqU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 17 Nov 2022 14:46:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240406AbiKQTqU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 17 Nov 2022 14:46:20 -0500
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FE0087571
        for <io-uring@vger.kernel.org>; Thu, 17 Nov 2022 11:46:19 -0800 (PST)
Received: by mail-io1-xd2a.google.com with SMTP id p184so2194130iof.11
        for <io-uring@vger.kernel.org>; Thu, 17 Nov 2022 11:46:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=B62JP/BlY85Dyj3ARXR6xb7galgPFfdbC7F/kQqsiCs=;
        b=tSRQaME9TeS6Kwrrep5oV/hChlObkVoB1xmBDHl/sloY9Ns/srA30OiZwCH8SJB7G3
         XTb8Kv6BeRLHY+b8g+9uaPcYNRdeo/j67eN1zTBMVwuTzFPBDy14wFMl7zdU6p0mhdDM
         RfmUKtgxdz1OeLzC1IY/ILBDU6JNeUbxzoEQLE3238mpJxjIQRekM5YsMzG8nC9uyzdv
         k9nJ8feifFx/Lq9321IYA9kkkNZvscJ9QuXR+LhlH82SOwyX/ERRczHEZ23e76ZmRS9v
         OsOa8Sd6fS4S1MjiRilY6HXYWUcUm9dvKUhAUwMNpBKVvcsPDscoLPWJ3U5K/fxeVyza
         mUSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=B62JP/BlY85Dyj3ARXR6xb7galgPFfdbC7F/kQqsiCs=;
        b=clpsdXe3gEBRgo/qAV2y63xn7EruYKox22DrxTe+xDSE6bTvL+4mbwtvcl6nmOaffn
         gSmmEniqL+A21lNuF1ldRhlRWQktcgrYtOGiU5piADJDHaVccAXoDQt2Usz3uaMj4Fy+
         JJYGLzyFcDDjASyMQej3MLEYr/vJt2q+e7uO4Uhf2UfcKF+d2Xe0IyGflcC2febrcn2Y
         NbkK4LyiNwsjAFAoAPbM1r2NEmo6iTOMZmNhK2U5spHDb4pBn5APa7NUesfOxzDdAxcx
         wK+qTiQLwpSl/XG28LrdYHgCtyox72HwD+IuyW5zuiSRvFdt03kH7gNTcXZhuvXYDHiC
         rHfw==
X-Gm-Message-State: ANoB5plomLCs6pLlS6vlzHoDkM0gkSDJ3fKowzXpRzswyeBeh4QKAhKE
        KuzEsn86G8yCfU9387bjP3S0WYX7OeB41w==
X-Google-Smtp-Source: AA0mqf4bRe9ku8vGF5czNFRx5HBGQSEWPHDsjB+pBUT899gbuOHo5R0g524QgGbaSnq4Qv65hR/Odg==
X-Received: by 2002:a02:6d5c:0:b0:375:2859:655c with SMTP id e28-20020a026d5c000000b003752859655cmr1769816jaf.1.1668714378391;
        Thu, 17 Nov 2022 11:46:18 -0800 (PST)
Received: from [127.0.0.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id n13-20020a6b590d000000b006ddd85d06c2sm606951iob.55.2022.11.17.11.46.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Nov 2022 11:46:17 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <ef4c9059950a3da5cf68df00f977f1fd13bd9306.1668597569.git.asml.silence@gmail.com>
References: <ef4c9059950a3da5cf68df00f977f1fd13bd9306.1668597569.git.asml.silence@gmail.com>
Subject: Re: [PATCH for-next 1/1] io_uring: inline __io_req_complete_post()
Message-Id: <166871437749.150999.223169641865316101.b4-ty@kernel.dk>
Date:   Thu, 17 Nov 2022 12:46:17 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailer: b4 0.11.0-dev-28747
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, 17 Nov 2022 18:41:06 +0000, Pavel Begunkov wrote:
> There is only one user of __io_req_complete_post(), inline it.
> 
> 

Applied, thanks!

[1/1] io_uring: inline __io_req_complete_post()
      commit: e353d23f304aad9ca0215cc0051757611686e34d

Best regards,
-- 
Jens Axboe


