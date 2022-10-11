Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F2115FAAC6
	for <lists+io-uring@lfdr.de>; Tue, 11 Oct 2022 04:54:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229514AbiJKCy6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 10 Oct 2022 22:54:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229847AbiJKCyz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 10 Oct 2022 22:54:55 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED90311466
        for <io-uring@vger.kernel.org>; Mon, 10 Oct 2022 19:54:46 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id 10so12050675pli.0
        for <io-uring@vger.kernel.org>; Mon, 10 Oct 2022 19:54:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AOkbJttegoZM886HdJQKhx14yi8CBB/BFNg/aQUAKrc=;
        b=vitJi9HNhKJ05CZV7NjB6WoqXd2SUugVXuAKBMPezTt8uhjZBYrU3WqiRVMP3eyvLa
         p25PD3NL1x0+y+elu4WB2UmNJuFWvK1GxfsTRdmW8ePhZddOPK+iFz3ujAGkpZ977SEt
         KpJUzZZRaeKFEPP8sarJiR2Yyitb0jlxLWIqJMTyToLsE1s+adhRefSpYQDUlmj1bt9h
         vvruOoloDKDcdTdMKRi5iw4oMY9jvATJiqoTnnBGSu4u460hNIqBeaZRABRzb1EXeCxp
         K0ecBOp/bwvAKqOtbba39BoRmNV2eWD8rrnPhQjRB03lyCaY46OJRihBvmbKxLwNYy6T
         FegA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AOkbJttegoZM886HdJQKhx14yi8CBB/BFNg/aQUAKrc=;
        b=1CnKr2Tc3J48PJjX0t/XbOfiIn27wbJaoYApxHqn4bQP+osV05ikp38Z90OgY7JPmk
         PFWeYuhD/JMCHQy2ig539JJYNY38tglBdZK/dlAS8nDsPXH/pqDaV/e/Ort+gqgqAdPd
         Kfa6z6Hh3LOs0E3FokDHLvNKu8vhAaiV4fB/MkDOPyN2TwU9vmK7puSUh/Mo4SYX78sk
         pPdrYTqt7ZH0QxzJeAUJH3BH1iXCtXbSO9d6lUgswde4V8pHS2A4GItj8UP+IgGaZdcA
         qSH6INfEofj106ojIUDEIVygTJ2FWHHd+KPfLvjLVu5PEziwh2BcfXnrw5sxO93euEok
         Zk3Q==
X-Gm-Message-State: ACrzQf1+9hojthPwZUxuNSEXDBNUqEuzuuZsWETjQpJemWEPSDbin2wu
        YDJ840MASE2NknQspY/I/iVW5esUzU1HfQkG
X-Google-Smtp-Source: AMsMyM6R5/dOJyZdf7xum0vLW2KNzxfQoq1kWTPzOxfmLzJCUGI9rcIAIV0ns+w8bGvpxR1FxUWn+Q==
X-Received: by 2002:a17:902:8347:b0:178:6e81:35ce with SMTP id z7-20020a170902834700b001786e8135cemr21273210pln.23.1665456885639;
        Mon, 10 Oct 2022 19:54:45 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id z10-20020a63c04a000000b004561e7569f8sm6931709pgi.8.2022.10.10.19.54.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Oct 2022 19:54:45 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, kernel-team@fb.com,
        Stefan Roesch <shr@devkernel.io>
Cc:     kernel test robot <lkp@intel.com>
In-Reply-To: <20221010234330.244244-1-shr@devkernel.io>
References: <20221010234330.244244-1-shr@devkernel.io>
Subject: Re: [PATCH v1] io_uring: local variable rw shadows outer variable in io_write
Message-Id: <166545688494.43404.17546041612960841102.b4-ty@kernel.dk>
Date:   Mon, 10 Oct 2022 20:54:44 -0600
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

On Mon, 10 Oct 2022 16:43:30 -0700, Stefan Roesch wrote:
> This fixes the shadowing of the outer variable rw in the function
> io_write().
> 
> 

Applied, thanks!

[1/1] io_uring: local variable rw shadows outer variable in io_write
      commit: 01c620cf9e96b1355c87545ed26521deef4aef80

Best regards,
-- 
Jens Axboe


