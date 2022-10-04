Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5E1F5F4515
	for <lists+io-uring@lfdr.de>; Tue,  4 Oct 2022 16:03:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229453AbiJDODj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 4 Oct 2022 10:03:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229913AbiJDODi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 4 Oct 2022 10:03:38 -0400
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF28F5D0C5
        for <io-uring@vger.kernel.org>; Tue,  4 Oct 2022 07:03:37 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id u10so5019986ilm.5
        for <io-uring@vger.kernel.org>; Tue, 04 Oct 2022 07:03:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date;
        bh=vNwxeB+FLdHiKxBNdz2WzQlcJEoJWzdQeE/hNEN7GVo=;
        b=dyMwF50HGPKkUYBwF/ou1mreMtqQpYeQcEjV8V2RRSzB5RRYAetV4B9XXhybB0Zo7e
         BChIXf5GWObJOvrsrGSmPuSUqa8bRXKMD+dP8TTV2Oa1G4LMv4UAHx8gpuGzbQqvmgJw
         al2w+eOtqACqjJDwYZ7cMKxIxt4+LCVFy/y1bk0vWkfVVrPN8bZTs1jz5fEx64kc68Ye
         oa0xOWAUFKsZNWgjqxVUQdHOGWgww/2S2QbjcGzHyz6zeNY3Ce6Jxv6vGgFrfQBztid+
         z8X6/WosGvmrPy28dMPm8ej0FjbMUxno4hyLY6hxU5y46xtXZpbihrz2VWjC2/6PkpUS
         N52A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=vNwxeB+FLdHiKxBNdz2WzQlcJEoJWzdQeE/hNEN7GVo=;
        b=dY/ZLMckPdm6bM7+c9eZB4GsNWRk4T/UiX6N6K25aVNBx5MdmYM4BY+J41BtOrly2c
         59n4Sx0J+f9voUSra6rbYjnEFEzCJbvu/YHMIJ1Q6ZF0Q+JxbL2sMPkpbcAUXXDtik8W
         bhP30G08eijSSNvfdY2vG5MAnjiIzdVEfx9ZDRZd/E8/n4h9PN2NnepAbJZKsRVdBNXr
         uzfRZHCzM4VpTyI1ipFD6o0wUR0ZMnh3NXr7iTvgK8XLZCT+MENm1RfEKqh72yzjAl9l
         IquMQb0rDVmpz3Xto8aM62s8gP5NowZB4TQ5DWl7NZtGzj37c4Bhea0baiWk9ih7Lymu
         N/BQ==
X-Gm-Message-State: ACrzQf3TSuCHI/W1NvHIkMZN4/71s3lj4QRJ5ZirS2wnb79pb5QXXiW9
        mhfOzDhYK+N35LCp4V8x57PKR4CAjBiBPg==
X-Google-Smtp-Source: AMsMyM6APmOb6riNGD9eWvOMW+DEK9GJtHt5HKQOGSce7eb+6f++xYOTH9vvVFhKEfrCxClKp+eUdw==
X-Received: by 2002:a92:cdac:0:b0:2f5:4776:9467 with SMTP id g12-20020a92cdac000000b002f547769467mr11893514ild.90.1664892216890;
        Tue, 04 Oct 2022 07:03:36 -0700 (PDT)
Received: from [127.0.0.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id f5-20020a02a105000000b0036332a07adcsm2462089jag.173.2022.10.04.07.03.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Oct 2022 07:03:36 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <8df8877d677be5a2b43afd936d600e60105ea960.1664849941.git.asml.silence@gmail.com>
References: <8df8877d677be5a2b43afd936d600e60105ea960.1664849941.git.asml.silence@gmail.com>
Subject: Re: [PATCH for-6.1 1/1] io_uring: remove notif leftovers
Message-Id: <166489221594.37976.3831072705735990561.b4-ty@kernel.dk>
Date:   Tue, 04 Oct 2022 08:03:35 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailer: b4 0.11.0-dev-d9ed3
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, 4 Oct 2022 03:19:25 +0100, Pavel Begunkov wrote:
> Notifications were killed but there is a couple of fields and struct
> declarations left, remove them.
> 
> 

Applied, thanks!

[1/1] io_uring: remove notif leftovers
      commit: 50dedbd905c7e6e40871ff5765622eed6109788c

Best regards,
-- 
Jens Axboe


