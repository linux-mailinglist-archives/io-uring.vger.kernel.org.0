Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A91B24309BD
	for <lists+io-uring@lfdr.de>; Sun, 17 Oct 2021 16:25:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343854AbhJQO1n (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 17 Oct 2021 10:27:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231156AbhJQO1m (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 17 Oct 2021 10:27:42 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13B3CC061765
        for <io-uring@vger.kernel.org>; Sun, 17 Oct 2021 07:25:33 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id o184so1310749iof.6
        for <io-uring@vger.kernel.org>; Sun, 17 Oct 2021 07:25:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rFZ0Jn5/odiPtbqwOvMA4pbQMBHIE+j2K4Ry7Pi3CLM=;
        b=HTsW/UrhwnGfFc9UO+Dd30JLAU29D3q0cLj64rounQTCtnZ9uOcsoX8L7TJYSNu2RE
         Vvv13khIS7IG0pXGyfsukUrT/N5wDDviNxUwIdd9OqCrknoohPXnSH4uDdtV/6reHE6x
         6VqHY/nMsQYEODnpKQE7yLzuAPzAVjcL6h3gCtneGnkxtBptQKHF06yXLjkP6lQ2wd+x
         1Jvxehw6YBsV03kuMt8Wkt2jw/ufCDIRgcQZWPmqjbtA7eb83r7u0eNMUoSsX29tPo99
         DlSUd/tLPABIv4cSpouz2SPNwcaNYgEa5XvO2j/o86lsYm0QH/VvMC6iHE/xuYDsbORt
         t5yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rFZ0Jn5/odiPtbqwOvMA4pbQMBHIE+j2K4Ry7Pi3CLM=;
        b=a9H5LxtXwe2H6+FOdXLToMs789/tOyHEC/+bfBAaV+V/bXjjJjUckzd3a4MtVBCB4Q
         LoF3KmlLuO6+sjpxZMus+wUmKtQiWyy57ZVAL6f67GIUvmJFKpvSUh0q42nDyAOu12jz
         6swVN3xNQRJIxgteJ7302SLW5H5Z8DTXRxl/ozA5kUVWkJ6ECYc/pQuMVnytlMs13m5N
         cUbqragAOpYdecWPvS3kf4LzYQNn+egehxifpz0A3uYhLn+v1vtfrPwbAb5W17UBJDyG
         8wC9iVar/KFNEKYGtuPTiEyc/plV7dpjbpVjZOjeyJGZ+1T9sOOzrt7DylQJEH5HBatY
         r5gg==
X-Gm-Message-State: AOAM533gBPxRxp3vhRqq3mqI3W1Mtt3VMNxIixBo0w2oRpzqSbxBOK0u
        wJ8502986kKBXqMSTrA+La+b7A==
X-Google-Smtp-Source: ABdhPJzpcIRVmKsESUvAnc7NxK6arVgO383HZIkSwBqsAXWdaAChkeavYtJ41OV4WCkfUFIFomr90A==
X-Received: by 2002:a6b:5c02:: with SMTP id z2mr10841825ioh.11.1634480732515;
        Sun, 17 Oct 2021 07:25:32 -0700 (PDT)
Received: from localhost.localdomain ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id r17sm5252034ioj.43.2021.10.17.07.25.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Oct 2021 07:25:32 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 0/3] rw optimisation partial resend
Date:   Sun, 17 Oct 2021 08:25:29 -0600
Message-Id: <163448072609.102114.3849123498935963727.b4-ty@kernel.dk>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1634425438.git.asml.silence@gmail.com>
References: <cover.1634425438.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sun, 17 Oct 2021 00:07:07 +0100, Pavel Begunkov wrote:
> Screwed commit messages with rebase, it returns back the intended
> structure: splitting 1/3 as a separate patch, 2/3 gets an actual
> explanation.
> 
> Also, merge a change reported by kernel test robot about
> set but not used variable rw.
> 
> [...]

Applied, thanks!

[1/3] io_uring: arm poll for non-nowait files
      commit: feabed278b191505df0ab7a382bc04b270ffb1f4
[2/3] io_uring: combine REQ_F_NOWAIT_{READ,WRITE} flags
      commit: c142f8627b24af12b958acd79c55761d52eab548
[3/3] io_uring: simplify io_file_supports_nowait()
      commit: c533d6e48e8a1d20e46c54231052b574005c2725

Best regards,
-- 
Jens Axboe


