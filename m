Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAD72680237
	for <lists+io-uring@lfdr.de>; Sun, 29 Jan 2023 23:20:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235130AbjA2WU4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 29 Jan 2023 17:20:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235405AbjA2WUw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 29 Jan 2023 17:20:52 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E97AF1EFD7
        for <io-uring@vger.kernel.org>; Sun, 29 Jan 2023 14:20:30 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id h9so1206727plf.9
        for <io-uring@vger.kernel.org>; Sun, 29 Jan 2023 14:20:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lacqyFGjA8ThZNfAehZgsKvPy0Xlq5p2QLHUHn107IU=;
        b=i02czyRsg3Kwp5Aa79EaR5KYv8zB8ZvRR+0nPw+jvvv/W09EJIrBVmc78o0Lvk4g4X
         fjp1CdQq992qpXAiAce0nCS8bCeLakRIsqiK6DgCfh7jogwZxeOmh6czz0a1SQjQNYQX
         hSUdbnamRTULch4ZFA8bquwHaz86gLMHq4++ZeZWfCQlsUrbBGrJkvWG1ZjhQ6bBQ8fi
         huJiHQX/cjfDo+V5nUez6SVGuN+tCrenLh9IPFb81svFBE0/c3gDt6LEYoyOOvbYY/LM
         N/JO2tozOm1Y6TyTdsKvsM//vWM8cKo3C2MlWC+2BYKsa7xPAtEvlQsiR/vfUUocY73L
         joJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lacqyFGjA8ThZNfAehZgsKvPy0Xlq5p2QLHUHn107IU=;
        b=bzq3YgRbDgtF6mA3m0a3eXMzLlah7nUteCOpxXgHkHoyLDFovIyhCH2UmBzHnA7aaq
         zwO8vIS9f2JU2KTZviiPmg0vXdmlRIEHku4ceghkWc3CUyQoL/h7W9gzV1rYgY4Np8KW
         P/4TI3FK/DvN3tAWq2NrRIXZZWnfXjCHb3kdW3VSSOtlmbxYEYkXDF5Qt5QupZ8CzV+F
         kJDK5CNTHpaeBl/8X37ZnwO6t2XIcpyp0ArTciflsrffy+CiabwQRm1ozXE0AX2FhECG
         nUwAqYVcnIdZ/D3G95KhMwjZKLDmLnpxKnC3GE5whLQZMig8fFrX+FWVXQ/5DVW05Q9K
         Ec6g==
X-Gm-Message-State: AO0yUKWGbuInzLLNgThSmGEAOBrA9557WmG6RaGfmBkZuCbwCswH496g
        enkJt67gpfc0+qCXKGeb93U5PwMXtF+Wax1K
X-Google-Smtp-Source: AK7set9LjrpLBSzaTTRNza93zIop3fWugEumR9jCAj2DUC1VLWmg/rVT86rfU5GWzWi2ef8N1LJIKg==
X-Received: by 2002:a17:903:22c2:b0:196:b0c:f0b9 with SMTP id y2-20020a17090322c200b001960b0cf0b9mr5671391plg.6.1675030830018;
        Sun, 29 Jan 2023 14:20:30 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id x15-20020a170902ec8f00b001968b529c98sm23603plg.128.2023.01.29.14.20.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Jan 2023 14:20:29 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Dylan Yudaken <dylany@meta.com>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com
In-Reply-To: <20230127135227.3646353-1-dylany@meta.com>
References: <20230127135227.3646353-1-dylany@meta.com>
Subject: Re: [PATCH for-next 0/4] io_uring: force async only ops to go
 async
Message-Id: <167503082869.59803.6963418229679534082.b4-ty@kernel.dk>
Date:   Sun, 29 Jan 2023 15:20:28 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12.0
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On Fri, 27 Jan 2023 05:52:23 -0800, Dylan Yudaken wrote:
> Many ops such as statx do not support nonblock issuing (for now). At the
> moment the code goes through the issue call just to receive -EAGAIN and
> then be run async. There is no need for this as internally the
> REQ_F_FORCE_ASYNC flag can just be added on.
> 
> The upside for this is generally minimal, and possibly you may decide that
> it's not worth the extra risk of bugs. Though as far as I can tell the
> risk is simply doing a blocking call from io_uring_enter(2), which while
> still a bug is not disasterous.
> 
> [...]

Applied, thanks!

[1/4] io_uring: if a linked request has REQ_F_FORCE_ASYNC then run it async
      (no commit info)
[2/4] io_uring: for requests that require async, force it
      (no commit info)
[3/4] io_uring: always go async for unsupported fadvise flags
      (no commit info)
[4/4] io_uring: always go async for unsupported open flags
      (no commit info)

Best regards,
-- 
Jens Axboe



