Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A720B6CAE58
	for <lists+io-uring@lfdr.de>; Mon, 27 Mar 2023 21:15:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232322AbjC0TPl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 27 Mar 2023 15:15:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232654AbjC0TPa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 27 Mar 2023 15:15:30 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC9D8272E
        for <io-uring@vger.kernel.org>; Mon, 27 Mar 2023 12:15:21 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id r4so5155910ilt.8
        for <io-uring@vger.kernel.org>; Mon, 27 Mar 2023 12:15:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1679944521; x=1682536521;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aDuzSc9dOHOYI9rHlptD+edKjvDmV7OlrXQ/SYd3dqw=;
        b=1ucQHfz34fx+2/YG8Z7gh16ybQLAMq7mx6Bca9xqSOa6bp9+fFwC8mdNNHbJm7tC+W
         kB0eonn/+IGb1UeTK9gt4L/V36OveTkOLkculIIYVeNEGmq+vAXWchSDFUVGXr8e0Zwp
         twAEpz16NMjbpeNRSG9pVQG+VdFmW6vAw4//X1I6pVDqMd+87/hzUllTJAOUGcm4VGAu
         5H8yb4m+u5xjdnLDOUpkVHlF3vKdm6uweMK19Fq1ovqAEFMWrmS/4gvfpb0iZqed824R
         81TFXp78JvQDVXHclS0XsiJKY1iwNVT2SkpK9Y9z0idhPCv+HgN66uMbSI0uNk+81Z0u
         XUIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679944521; x=1682536521;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aDuzSc9dOHOYI9rHlptD+edKjvDmV7OlrXQ/SYd3dqw=;
        b=6RSrTPOwUOSxX6U+3yMv/PWQYKjEahTpedgsKjwfwJfX9F4sFgZQMvat96plqNlHx2
         Es0oKuPnM/YYmV5RvLxpw//MV0WPFdwWZOH0aPIM7V3b0/Cu8PSHld1TLhlxxCpBAsXq
         ZcwxydX9VSOsNN9X7rtAtvFu5fmi7uIZaAM4iD5/rO8telxALQpWYL9bSGspRb9O8v58
         2ywdOdpxjXubjDmNpPjpl9B0RmruoRHde5uLiu5O1sRZ6SZVUxVYGedGn73GH7OJKtVU
         W+JBweWweppuKGoyJ2aDyn09o2qyqb6bpG+hWIVIxoNGTONnubU28tpkaYOTGyDknz4N
         BZpQ==
X-Gm-Message-State: AAQBX9eKF0KHOw48KDiGbe6+4ZDQr6WLRfIMVjBs2HSWipyoSUspMqbn
        kDteoMmHn/0NhGAx2qN/7y5ZyO0SxaiikcLQPhIFIQ==
X-Google-Smtp-Source: AKy350b//0q+mLRAy/mB5C31jJjGEUAquzpsHXNsU1Iu33wW0agZ26ENrQ7OzFn3zNZTE22ExH7lcw==
X-Received: by 2002:a05:6e02:d4f:b0:325:e46f:a028 with SMTP id h15-20020a056e020d4f00b00325e46fa028mr5802649ilj.3.1679944520930;
        Mon, 27 Mar 2023 12:15:20 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id q54-20020a056638347600b003c41434babdsm9194154jav.92.2023.03.27.12.15.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 12:15:20 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <f05f65aebaf8b1b5bf28519a8fdb350e3e7c9ad0.1679924536.git.asml.silence@gmail.com>
References: <f05f65aebaf8b1b5bf28519a8fdb350e3e7c9ad0.1679924536.git.asml.silence@gmail.com>
Subject: Re: [PATCH 1/1] io_uring: kill unused notif declarations
Message-Id: <167994452044.167981.9809537298417159318.b4-ty@kernel.dk>
Date:   Mon, 27 Mar 2023 13:15:20 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.13-dev-20972
X-Spam-Status: No, score=0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On Mon, 27 Mar 2023 16:34:48 +0100, Pavel Begunkov wrote:
> There are two leftover structures from the notification registration
> mechanism that has never been released, kill them.
> 
> 

Applied, thanks!

[1/1] io_uring: kill unused notif declarations
      commit: e3546d2e01e9a942b2c3591f76145a1e90f9b13b

Best regards,
-- 
Jens Axboe



