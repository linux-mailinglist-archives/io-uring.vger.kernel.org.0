Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FC673B557D
	for <lists+io-uring@lfdr.de>; Mon, 28 Jun 2021 00:23:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231702AbhF0WZe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 27 Jun 2021 18:25:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231644AbhF0WZd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 27 Jun 2021 18:25:33 -0400
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66E9BC061574
        for <io-uring@vger.kernel.org>; Sun, 27 Jun 2021 15:23:08 -0700 (PDT)
Received: by mail-il1-x12c.google.com with SMTP id z1so15645344ils.0
        for <io-uring@vger.kernel.org>; Sun, 27 Jun 2021 15:23:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ArV2u9M6NA3pMlzT9Pf/ez8w6s1ZFvUbTII8GuCoaZg=;
        b=DF1AOTLEVnd2MDIRoiVd8M2z9mqGpLQebYlHNxYmzRminHlwav9q5/2VY4K9HQNYZ+
         6RKQIzqWNmiCZEumrUStPpwbM4Xbsp966ooIc/h9z9HzcZ720H3YL+iCWTr9F+UNEWDf
         GRqxC6rTw7bMkfyhodtvUiH8/bpK1hvsI0FS1EjWBJP70W+JIhb/LL18mVQWW09WW4eY
         7FxyNq353m9O/omyZY627/ex6XD4U3LVaiPYmf3F6rqhqvy2D0AzIvuohCG8eKjxQ+kP
         zpAR2f4EG/GUPwZOCxrJQmfR5dmdIln14LTlUCF6IPzUHUszwcPeT60L3phenimJhfx4
         hAPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ArV2u9M6NA3pMlzT9Pf/ez8w6s1ZFvUbTII8GuCoaZg=;
        b=Xm4wolASyB6JPNLBKOaFryYPkUvnzZIncUcnr9DSD67hPZ7Q2Tw3rVTkF4IPJTpfQR
         iiNIFUXOAE3RY2w/TQn6n2G4CRcKUwvo2oGCeklwZCPWlbpGtTKUDNqzVTXFXtwbUbuk
         +ijxf8ZVmxEoh8D6qVwrG5uTLhkv6W4MA0y/yHjylo0R1Ee74nUHJovjB+hRVRGEvkWK
         u2Bkr+vFCAT+e/xWNXRVp2Sp7lkuaX4mPyCYdL8m/MRj1p/pcoU8FZByQ18qGv6dXRyq
         FYBNkcQ5aMv6t/aTdO7XJYYQwEFOlqSlvEVuoPvgGx+tPBqPxE6tkpoyCduMlAiXxqaw
         MzTg==
X-Gm-Message-State: AOAM530I4c6g6KLngKoJox7CnajgI5NWcI+iZZ9Ubjk0LPuwDrKzwjlc
        kY+uI6zUKgHKTX3t3YaaiHUS8g==
X-Google-Smtp-Source: ABdhPJyQZHERb9JgXgY62lJ+0JPVKs5Q3puq0QHhpSTWYPT2MNG2KPA5BdPqOGwIyhTLzrKSikYOmg==
X-Received: by 2002:a92:b50d:: with SMTP id f13mr15849153ile.253.1624832587821;
        Sun, 27 Jun 2021 15:23:07 -0700 (PDT)
Received: from [192.168.1.134] ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id z17sm7251354ilp.69.2021.06.27.15.23.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 27 Jun 2021 15:23:07 -0700 (PDT)
Subject: Re: [PATCH] io_uring: code clean for kiocb_done()
To:     Hao Xu <haoxu@linux.alibaba.com>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
References: <1624830485-47217-1-git-send-email-haoxu@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <5b244641-fbb9-84af-1afd-26769f889cd2@kernel.dk>
Date:   Sun, 27 Jun 2021 16:23:06 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1624830485-47217-1-git-send-email-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/27/21 3:48 PM, Hao Xu wrote:
> A simple code clean for kiocb_done()

Obviously correct - applied, thanks.

-- 
Jens Axboe

