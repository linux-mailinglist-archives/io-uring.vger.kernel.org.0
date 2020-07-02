Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27729212FD0
	for <lists+io-uring@lfdr.de>; Fri,  3 Jul 2020 01:03:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726501AbgGBXDp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 2 Jul 2020 19:03:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726017AbgGBXDp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 2 Jul 2020 19:03:45 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 139D0C08C5C1
        for <io-uring@vger.kernel.org>; Thu,  2 Jul 2020 16:03:45 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id 67so9095668pfg.5
        for <io-uring@vger.kernel.org>; Thu, 02 Jul 2020 16:03:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=RHRHmNyTbbKRD+0J0gOD/xwBweYLpFiV+WE2Fhb0MS4=;
        b=AEYkqwikltjub0nDMSBILhrlWqhxIQtX1GAKRfzVrDgiGRkFqAsS3S8xuI2fBPniJI
         c0Si2QS6Ilp9Gv27ecRswJaSpCGUqtitFdIoT4BAp/fB9rMtAyVcAAPsZopvJT6K3OqQ
         4pCyi0wdJCfIuZ8Dux+shbRoe1hfxC2b4I6UNgBjVcZIH5gIR4mN2nw/KGv2ydU8nC0I
         E1iKNxbGLD5OmT/DW5KHd5C2KuWXM1skkid0Bir/dj7/xqcq1xWV010vf678zPsG87Cy
         P/bBoZgVmAh51JAoYC5ZoYLRbePjgLZbSKSY2QPWgDIvC+s494kN93ZttJDz0ovV/hvk
         iDng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=RHRHmNyTbbKRD+0J0gOD/xwBweYLpFiV+WE2Fhb0MS4=;
        b=K0phej2Yz8dmFXXnVatxOpN7WIhrpCG7p1pvgVwrUtihUKycMuA2g7wcfKdqaTo4wK
         PC/bSubMTa4iN9Da5nm+c+l7Vyu5KmhPBJ9XjdrLO3XTYNKemdAJOaZ3n8fK7gIW1TrO
         muVTLkfSXMTKFzBsnKrE1+LH5rjpLNPBaz4I7QitNw4wKQJ79VVyv1f+jElCx63SV7fu
         8mZG/KGHHN74LdiRpK54ySL1DDQTruCfBS7+54r1Sg66LsfJJkf0o1XJdVsC04wlmprn
         Tq3K06kxtUEqk/yYvHkrKKsPmsMnBx7+UG+rTjqfwOCB9hRm8TLzpwns6A/ukI+GHmWb
         GG/A==
X-Gm-Message-State: AOAM533LAtE01t2Wvcnt6VR0FEbY1G8LmfNpvrpNw+DSUhicDlnrfR3U
        NJngLPoQdjU+8LCcuFL3DVEawuUDCUgWzw==
X-Google-Smtp-Source: ABdhPJzeYxam7lyhnenUVxRQZhthrWtqzEs2qvqwwWETzArhfXjltsQofCtIfnNk/BLnCkFHfUlYNw==
X-Received: by 2002:a63:4543:: with SMTP id u3mr24663879pgk.398.1593731024380;
        Thu, 02 Jul 2020 16:03:44 -0700 (PDT)
Received: from [10.174.189.217] ([204.156.180.104])
        by smtp.gmail.com with ESMTPSA id g5sm6812763pfh.168.2020.07.02.16.03.43
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Jul 2020 16:03:43 -0700 (PDT)
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: 0.7 liburing release
Message-ID: <135262c4-0abc-2c88-fe34-38870d2aac67@kernel.dk>
Date:   Thu, 2 Jul 2020 17:03:42 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

Getting ready to release 0.7 of the liburing library. If anyone has
changes or fixes they'd like to see in that release, please make me
aware of them as soon as possible.

Thanks,
-- 
Jens Axboe

