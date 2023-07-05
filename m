Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AC5E74896F
	for <lists+io-uring@lfdr.de>; Wed,  5 Jul 2023 18:44:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230057AbjGEQoo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 5 Jul 2023 12:44:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231315AbjGEQoo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 5 Jul 2023 12:44:44 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54FB510EA
        for <io-uring@vger.kernel.org>; Wed,  5 Jul 2023 09:44:43 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id 2adb3069b0e04-4fb7589b187so10903360e87.1
        for <io-uring@vger.kernel.org>; Wed, 05 Jul 2023 09:44:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1688575481; x=1691167481;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7jnWEimCPuEFzRaoWIXYND1Ff+J3FjL3uabcuEhTkIY=;
        b=MBbzIsz8K1+aEG6pYPHryu/4h1rdH64ggVB2kyHV24gzxqInyoBhhy9NumVuwlS4L+
         pxlyuXeih186lr/nwUmG8VYDKG9NU2kCZsTrZnByfw1BXemr5VbR25Z3leTgAosMcWqa
         +n9lKjZ+oyCIHrqjoX/Hi2i0hQ9F4TwNRrPcpOBbj3B3lDNODoG8TY0lQf9MezXCH5+p
         LPHjZByZ3jODe753tp7BxQy1qpiez3BNoeT2N1lNuq/NMDD89aaT2NRA6cPsHvnnOmuV
         o/O9R3/K0HVgYjkEt1mzUM7kocE+hFb78pPNfkJ8jNWfIqry1cmuSGwQsMSh0fByyK9m
         iw4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688575481; x=1691167481;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=7jnWEimCPuEFzRaoWIXYND1Ff+J3FjL3uabcuEhTkIY=;
        b=Z/ngtA+WjBz+gdVq7iagEoKuam8lT+DCRBIR0eF+wpv9UKjPvHo1v+o8OEmQniMDNN
         fJJH1v4Mj0ISi33aOj+jQdhYNXHZ74B9zM/acQnY8LctFN4oRRhxLRIRsn3A6dZcCTW9
         lvtDSuqyQS2M0FnnLdprN34pALmsUNeMjOa20ircP6TmQtdlpgWmC+mT4CG5Mm0hJPDo
         h15UnPWvq5NlTRLnKFPw+X+60IqMsfjmzYK2gBbQdVkPIm/KQGGUIJC/m1nPo6FSwYK0
         XtOjbnv2/m3wVbCX+B4as0ZgJXWnsAVbT95lak3CX5DAa1H7nVf4vYFJZm7wbBAG1lRp
         7HuQ==
X-Gm-Message-State: ABy/qLblEukgoOpeGaa+5NGsMWijHcdDXhKbz/whjZVHVw8dzbluUI88
        eFJprGS7E6EjSpKYdSHIJozS0goKzw==
X-Google-Smtp-Source: APBJJlGRlmzmcBARfrOA+wzpoAFiPfmWgl0HI62fd/E9uhZKzl0xM8CXcfn2Gci5cYQiki+1EYiM1Q==
X-Received: by 2002:a05:6512:2010:b0:4f8:e4e9:499e with SMTP id a16-20020a056512201000b004f8e4e9499emr10689810lfb.12.1688575481059;
        Wed, 05 Jul 2023 09:44:41 -0700 (PDT)
Received: from [192.168.100.16] ([81.26.145.66])
        by smtp.gmail.com with ESMTPSA id q3-20020ac25a03000000b004fb9d7b9915sm3423516lfn.37.2023.07.05.09.44.40
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Jul 2023 09:44:40 -0700 (PDT)
Message-ID: <62f84473-f398-fb00-84c0-711c59bd9961@gmail.com>
Date:   Wed, 5 Jul 2023 19:44:39 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Content-Language: en-US, ru-RU
To:     io-uring@vger.kernel.org
From:   Artyom Pavlov <newpavlov@gmail.com>
Subject: Allow IORING_OP_ASYNC_CANCEL to cancel requests on other rings
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Greetings!

Right now when I want to cancel request which runs on a different ring I 
have to use IORING_OP_MSG_RING with a special len value. CQEs with res 
equal to this special value get intercepted by my code and 
IORING_OP_ASYNC_CANCEL SQE gets created in the receiver ring with 
user_data taken from the received message. This approach kind of works, 
but not efficient (it requires additional round trip through the ring) 
and somewhat fragile (it relies on lack of collisions between the 
special value and potential error codes).

I think it should be possible to add support for cancelling requests on 
other rings to IORING_OP_ASYNC_CANCEL by introducing a new flag. If the 
flag is enabled, then the fd field would be interpreted as fd of another 
ring to which cancellation request should be sent. Using the fd field 
would mean that the new flag would conflict with IORING_ASYNC_CANCEL_FD, 
so it could be worth to use a different field for receiver ring fd.

Best regards,
Artyom Pavlov.
