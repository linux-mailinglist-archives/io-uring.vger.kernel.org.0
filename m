Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49B97589DEC
	for <lists+io-uring@lfdr.de>; Thu,  4 Aug 2022 16:53:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239686AbiHDOxb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 Aug 2022 10:53:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234742AbiHDOxb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 Aug 2022 10:53:31 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA15D2613B
        for <io-uring@vger.kernel.org>; Thu,  4 Aug 2022 07:53:30 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id w7so57624ply.12
        for <io-uring@vger.kernel.org>; Thu, 04 Aug 2022 07:53:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:in-reply-to:references:subject:message-id:date:mime-version
         :content-transfer-encoding;
        bh=N46puxtkUl/rP0ISPSOJGy3axDKOZZ6Pa8d0+82xEWI=;
        b=StjXhV3DAVMWIIpk08Pw6GZFt3k5ltHUZJFRMp+lT24RmWpn2RzItyh/s3gJ1Q5XQQ
         HJqfvMJJkQOz0MTgGNdTJ5wGdhFiSEH4suiGC1x7RcKc1VZkADVcK6UNFQIlKjgEul3W
         itouaeLDaaBJVKEmrS3n5xG2H8wCvX1qcU2GLyYb/3CYnVrKV+stxseQ5PjX+qdnoIfp
         VyIwzEaQpf56W4PQ/VvQ7S82h70wHco0n7Emiwz7QVMaWsBf7c/34EYcVf95uetQE3DK
         ux7XbrGJgm/ECi+7DkSMLeLnDmvxwsQ36TV68g297WKaDqMgOllklkngvBZEHc94YgPt
         YZeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=N46puxtkUl/rP0ISPSOJGy3axDKOZZ6Pa8d0+82xEWI=;
        b=MUqaGEKVIns3nj5sx1x3rEgRcjeNrma7ybQjzu173E8oYLRHpcZnnFqJj11PPk8eov
         jBxRxDAgONwKvJssDpJmH57NIUYnIUt/82Mfvsmw2oFfdhauhNIVy0yTXy3NtPaCe2rx
         Eo4TIuFskE1AuR0yGHhI1JpHuMb9chDMjnaYDKUjPUhBDObzx3rO2gkVgyBoMhpA3nno
         +GjFeDwYtPm++w2QncBhM5kTqz7Uk44zvBk00lCs5i14LPDfdjuEC2OKsRQNrbr5Ioj7
         V85sq+f7CblqKppuBD50VrFqIqri8MUDeNcSzQfQQxbt73kumJTdBR/pbUeTCSEH5evG
         hJUA==
X-Gm-Message-State: ACgBeo3lLDMpySQs/R4CmquJxBe9PxDxzhSCSOdcqZs0nd9ppnoJPYYd
        4BSx/4IpMihA6k+OgJe0Bx+/G4Q4/N0zlQ==
X-Google-Smtp-Source: AA6agR4quTDU+KYSXcD5Kf+zN1fq9ZniOFF7FYY5L+DjAtE/6hRXRVT8X1wKLdFwfAzXEiSOSKHQnQ==
X-Received: by 2002:a17:902:ab13:b0:16c:bc10:85a9 with SMTP id ik19-20020a170902ab1300b0016cbc1085a9mr2196481plb.7.1659624810317;
        Thu, 04 Aug 2022 07:53:30 -0700 (PDT)
Received: from [127.0.1.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id r11-20020a17090b050b00b001f312e7665asm1237934pjz.47.2022.08.04.07.53.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Aug 2022 07:53:29 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     asml.silence@gmail.com, io-uring@vger.kernel.org
In-Reply-To: <b876a4838597d9bba4f3215db60d72c33c448ad0.1659622472.git.asml.silence@gmail.com>
References: <b876a4838597d9bba4f3215db60d72c33c448ad0.1659622472.git.asml.silence@gmail.com>
Subject: Re: [PATCH 1/1] io_uring/net: send retry for zerocopy
Message-Id: <165962480958.936450.9977227735773030762.b4-ty@kernel.dk>
Date:   Thu, 04 Aug 2022 08:53:29 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, 4 Aug 2022 15:15:30 +0100, Pavel Begunkov wrote:
> io_uring handles short sends/recvs for stream sockets when MSG_WAITALL
> is set, however new zerocopy send is inconsistent in this regard, which
> might be confusing. Handle short sends.
> 
> 

Applied, thanks!

[1/1] io_uring/net: send retry for zerocopy
      commit: 4a933e62083ead6cd064293a7505c56165859320

Best regards,
-- 
Jens Axboe


