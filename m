Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22454424A52
	for <lists+io-uring@lfdr.de>; Thu,  7 Oct 2021 01:04:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232361AbhJFXGX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 6 Oct 2021 19:06:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239778AbhJFXGW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 6 Oct 2021 19:06:22 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55D41C061760
        for <io-uring@vger.kernel.org>; Wed,  6 Oct 2021 16:04:30 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id r201so3840883pgr.4
        for <io-uring@vger.kernel.org>; Wed, 06 Oct 2021 16:04:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amikom.ac.id; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uJpJM4vUNuRPPfE7iblo3bLhMOlFz7jobvZ81bXzu2o=;
        b=XsFROh8hZnIlxnvC7w3q7Bui/EZ5gKFIlN7nj1ZRz5ifeoOQpall5Ay2mKHRZF6Pn4
         HnwueACVn7/kcUadmOUmza/iH6vklwg4EAxgVJZPOEDCWprYhm/J9c7QEG/jqY5fOlG4
         CiI3Wl13uBv/G6gH+pzEmsznFefcj+xWeI9/UbmfsXrIUXkEQnCUJa+INRiXiISC3/Tl
         7X0kUSUZtrW/lk7yUByr0Hc/TzJMjZSGZP18paaBI0EfSpAB0WkKCErZmvK+w7YYe0U3
         Dn7Y9mzLQf8F4ESwzs/7sZluLJYbQnAhxGUIQ/oDO+ijifh1ljCjPG2qAeAwwmdGRLrA
         MIYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uJpJM4vUNuRPPfE7iblo3bLhMOlFz7jobvZ81bXzu2o=;
        b=5hiFEBW0xOd6Is84GB8r7tOMRR1kUiNZF82TWPsNJvr0um/kij2cOU3AeU7hJvv8qE
         Y78kpTfTmAVZ3IWTaJBVGHILg4UqjDNFD1PMnKGsxqowNatOUz7A6/6UGAdifCMFX188
         Q+ayS1rYE3W2W+ervefc1apiP2cgKRcPeiCXOfT5CIfHIqDS3K/0vFxXwiOONqXX3WC4
         Fx85iy8Y/CCWIsV5DCuDKfQSzk6ksURfg9XXkEuFowCc7aRHGIjOB6UvwLco6G0cYEoN
         3cBGcFu0dTIR+Vq1UZOWfmfvF0G624lM+sJp2CfJs9q+1Wjj4vYo9kSODba/scN/BsMG
         dZnw==
X-Gm-Message-State: AOAM5333JfUyG9OgoWOE/JXGwMJUYej30UzC9ra1Eudykw6oye5e3x3O
        Rs1BGjMV+kpbEGB3G1ki9/Teaw==
X-Google-Smtp-Source: ABdhPJycBBM5m2HB2H646CrUHjKBCswV4jL6Zd21k3zzAKoVt/wf+XpaCbD/WHwBgZoUX8MJDLvtMw==
X-Received: by 2002:a63:5b09:: with SMTP id p9mr588765pgb.321.1633561469735;
        Wed, 06 Oct 2021 16:04:29 -0700 (PDT)
Received: from integral.. ([182.2.71.97])
        by smtp.gmail.com with ESMTPSA id b10sm21335048pfi.122.2021.10.06.16.04.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Oct 2021 16:04:29 -0700 (PDT)
From:   Ammar Faizi <ammar.faizi@students.amikom.ac.id>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Bedirhan KURT <windowz414@gnuweeb.org>
Cc:     Louvian Lyndal <louvianlyndal@gmail.com>,
        Ammar Faizi <ammar.faizi@students.amikom.ac.id>
Subject: Re: [PATCH v1 RFC liburing 6/6] src/{queue,register,setup}: Clean up unused includes
Date:   Thu,  7 Oct 2021 06:04:08 +0700
Message-Id: <20211006230408.1210525-1-ammar.faizi@students.amikom.ac.id>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <c50244e5-6018-b562-713a-0c1571001a3e@gnuweeb.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Oct 7, 2021 at 1:45 AM Bedirhan KURT <windowz414@gnuweeb.org> wrote:
>
> Ammar,
>
> As you told me through Telegram, I have reviewed your patch but        
> aren't inclusions important for some functions and/or commands  
> to work on compiling process?
>
> I mean you surely know more about this but, from what I know
> with my Android development experience, omitting/removing
> inclusions and/or imports from files to be compiled or
> scripts to be used might cause issues during
> compilation/booting/usage process so I guess those
> inclusions were just unnecessary?
>
> I'm also aware that Android is no match with Linux kernel but  
> I just wanted to point that out.
>
> Regards,
>
> Bedirhan KURT.
>

Hmmm...

I don't fully understand your comment. But as far as I can tell, those
inclusions are duplicate. We have them in the lib.h and syscall.h
after these patches. If this removal caused a compilation problem, I
would have caught that before sending these patches as I've at least
built it.

-- 
Ammar Faizi
