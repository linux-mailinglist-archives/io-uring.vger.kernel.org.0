Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FB814431AB
	for <lists+io-uring@lfdr.de>; Tue,  2 Nov 2021 16:26:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232650AbhKBP3U (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 2 Nov 2021 11:29:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234230AbhKBP3T (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 2 Nov 2021 11:29:19 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AEDAC061714
        for <io-uring@vger.kernel.org>; Tue,  2 Nov 2021 08:26:45 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id g8so24700593iob.10
        for <io-uring@vger.kernel.org>; Tue, 02 Nov 2021 08:26:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:in-reply-to:references:subject:message-id:date:mime-version
         :content-transfer-encoding;
        bh=j8aP7vFw6Ft/0wkXv5MlCzc+VSr4+WusrGVqmQuZC5U=;
        b=4zM1suJzq8+NlxSYh/PaZjrhFNG2o5rflVVJ0LJTRTvKaw4VYoZKNkjZeMGm0kFZhq
         pXxFPxjzdq7tGp5gdppOwxkbNBjcm057WQqiSJ4VDtKq996qV/aABYpfmzVaZ4Hd0Jru
         OlQ1/y9BjjSdxaIrgO2QpITX5iNtPcDkP0ZDrM0uzYSV2/nLM20uMOTZq7irUcXZheY0
         oQENBvHjMW867nHiDJYDfn6OgVAM6TiFMvnVydl4NzWM09y8Ylyvk9wUOE+xzEk15s8F
         LhT2siqUtK+Nqqes7VIu5e4rhJruhMNFMhqfPEfyjfEzhSabEcim4YD+tdXvtlDr/YgG
         grfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=j8aP7vFw6Ft/0wkXv5MlCzc+VSr4+WusrGVqmQuZC5U=;
        b=JyKz3np0EfJru2yIfz1QBz4H1gPII9eG68r4H2/acNwI0IHUApTBoCQ+aAi4sq8hDh
         j1Rdr5Z+Zr9COCL9GXEX1g4j844TGLM+DQRXfBCH63qV85uH6cnT1B4uO70rrv0z3sRd
         ssGMC/LbtsT0mrP2VbWrrO4FkL01OpcBr53Pm0gGt7C9+PYP7izMoZuKjkwiZLE5D1o8
         P1unAbePc7dqkKCF/jTKbVcpBoLdkilr/NpIzwmVMuV5/UQHIl9jA3VC7a8gtkgYQLel
         aM2qSitewbzBX/imd+8LZXWr9YIVLFEGh97KNMwFBWygupP9f9soUq4633vVACgbbyUM
         zzXw==
X-Gm-Message-State: AOAM5319LcevGJQ0bPjGb78Rjm1qdBb5I229wtk5QsFeCdDC8EmgqnJ2
        6CwjUuid9Gs/CMGdg7PpdzMY7NeCL7rUqQ==
X-Google-Smtp-Source: ABdhPJweY5DZm6+J6ghF+gQEBmpEXl9aqlmeX4zIbVla31hRuz2SmEL8LOMIe3t4ephfRJTHnAPluQ==
X-Received: by 2002:a02:b10e:: with SMTP id r14mr15427227jah.81.1635866804346;
        Tue, 02 Nov 2021 08:26:44 -0700 (PDT)
Received: from [127.0.1.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id k8sm700868iov.11.2021.11.02.08.26.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Nov 2021 08:26:44 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <130b1ea5605bbd81d7b874a95332295799d33b81.1635863773.git.asml.silence@gmail.com>
References: <130b1ea5605bbd81d7b874a95332295799d33b81.1635863773.git.asml.silence@gmail.com>
Subject: Re: [PATCH 1/1] io_uring: clean up io_queue_sqe_arm_apoll
Message-Id: <163586680384.316469.13991172820438493215.b4-ty@kernel.dk>
Date:   Tue, 02 Nov 2021 09:26:43 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, 2 Nov 2021 14:38:52 +0000, Pavel Begunkov wrote:
> The fix for linked timeout unprep got a bit distored with two rebases,
> handle linked timeouts for IO_APOLL_READY as with all other cases, i.e.
> queue it at the end of the function.
> 
> 

Applied, thanks!

[1/1] io_uring: clean up io_queue_sqe_arm_apoll
      commit: 9881024aab8094a53756c7aee42564306c8e3580

Best regards,
-- 
Jens Axboe


