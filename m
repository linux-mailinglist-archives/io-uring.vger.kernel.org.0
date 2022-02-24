Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 944E84C2DDA
	for <lists+io-uring@lfdr.de>; Thu, 24 Feb 2022 15:06:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232525AbiBXOGD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Feb 2022 09:06:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232103AbiBXOGC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Feb 2022 09:06:02 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 865E125292C
        for <io-uring@vger.kernel.org>; Thu, 24 Feb 2022 06:05:31 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id i1so1807180plr.2
        for <io-uring@vger.kernel.org>; Thu, 24 Feb 2022 06:05:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=eKVIdnwxPjjou58IirpwHd9I3xRbAK2mlXSTl2Yo7p8=;
        b=VpDwEPzcxF/R6DL4egHNMnAR6Yz/2LnlMdqyS6YfGwfmTqeTQrIB6937E+DcrU5T+d
         dJsBKtHFbBSTY8Syt4H5EHf9mwfQcTNMcs1pp9gWjPyMHpZhZZqaCGPhK19KgxNFS/Sd
         kLK9+VLEKo0N1UCVF+bCxdkN58WouRD4G9eue3bkVN7BLC7itD2Qne+KegUJKA4aZ7mQ
         XubLud/gKc19vHhqDeeFVHt1bFfpGe1FtbAnZW2kwfM/SS9HZCwh8ftMNYntpH320lRY
         fExRprNsEC5BQYNQlJ7cXUEsqLJmETRW11Mt3jrhi9nzfHso+u7hhH+qN/kyxOrzEPxo
         Gh3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=eKVIdnwxPjjou58IirpwHd9I3xRbAK2mlXSTl2Yo7p8=;
        b=vUHAefZR4hY/2Bwmmk8y+c9m1foNTx0wqr2UMTj26w2A9HB7e9hbsQyLiakDH4UFdl
         HTxrQvTcEwF5gKsg671ogk/+wllHiO626v0n4nafzP0ZWTVSYGhXsUDcb4O5tSmLmwzw
         JEPDYgqAGV4ORCJ2VUXYp+L/VkyGhK1fT4UW9t5uN9RTqIQdlztWysa0pQSxtOBpo00K
         YjXQEdzPb9JCa8KZPask16qXVRFqA52p2xw7gExI89o/ss3m+BfjhDZLRdItbDB4wQyA
         aIE88cwJyA4x5D/NqiZkdySFGScExciJTFv+wv3bEB4PaLcUIrSmkymydZ7uMwfZFW6g
         BoJw==
X-Gm-Message-State: AOAM532eDMmmkB68Qm9OAgAClCY5lxkk8nRNsMjnrSSckPg29/QBuvRs
        DfTBoQjg5Kn+vUgiII5TADwX2kNC/PNfFg==
X-Google-Smtp-Source: ABdhPJwXwqNnbH/gJYc0dLL/MiG/QHYCYLdhNN/bL3OfTtffe0pKvTpYf6Q9L68jRFZDOU1VbOVTPA==
X-Received: by 2002:a17:902:ab18:b0:14f:ce6b:f6f5 with SMTP id ik24-20020a170902ab1800b0014fce6bf6f5mr2704217plb.152.1645711530977;
        Thu, 24 Feb 2022 06:05:30 -0800 (PST)
Received: from [127.0.1.1] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id il7sm515457pjb.28.2022.02.24.06.05.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Feb 2022 06:05:30 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Dylan Yudaken <dylany@fb.com>, io-uring@vger.kernel.org
Cc:     kernel-team@fb.com
In-Reply-To: <20220224105157.1332353-1-dylany@fb.com>
References: <20220224105157.1332353-1-dylany@fb.com>
Subject: Re: [PATCH] io_uring: documentation fixup
Message-Id: <164571152996.5018.6090857289971256488.b4-ty@kernel.dk>
Date:   Thu, 24 Feb 2022 07:05:29 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, 24 Feb 2022 02:51:57 -0800, Dylan Yudaken wrote:
> Fix incorrect name reference in comment. ki_filp does not exist in the
> struct, but file does.
> 
> 

Applied, thanks!

[1/1] io_uring: documentation fixup
      commit: 6810a554d2740bef3883cf3d71057aaa129e1ce5

Best regards,
-- 
Jens Axboe


