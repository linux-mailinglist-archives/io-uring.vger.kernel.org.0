Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57A0458ECA7
	for <lists+io-uring@lfdr.de>; Wed, 10 Aug 2022 15:02:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232401AbiHJNCD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 10 Aug 2022 09:02:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232460AbiHJNBq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 10 Aug 2022 09:01:46 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 980306B16E
        for <io-uring@vger.kernel.org>; Wed, 10 Aug 2022 06:01:45 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id 73so14270915pgb.9
        for <io-uring@vger.kernel.org>; Wed, 10 Aug 2022 06:01:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=CXppoyJ0a8DJfJ97XiyTlWFeTlRIyHv+N6QdhN3441o=;
        b=MaBUYPpL8tQKjo4TJL1DL7dSuEfeR4Q+xc+8SvGW7jFq1YgUgjNlZE6TdUunGsAYnK
         ZlJIIycT0ceiK258TD35NY3Iqs0g5fOLWyaNrT3b1ci2yIxWf7vx89Fzsbga33+4zMYj
         SjzGK0Wj/Mb2G29zQN2qrL4vmn9e5An5kDgqasb6AsULiumVc/b0K9Od5JrqSIHOKBt7
         yTgdK5ZQ1KUBhax1yQi0+Pr9X1nv/EH9TvGs/tHHkZFqfW9UG1P1OPlbVNAJtdCzqGSD
         lLj7kMkBIUslSMeIheT6oCPRcqnoE4AeKpB2AtrS3lDKxJbvREUEk1NIPRpGkqXpeWo1
         NP0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=CXppoyJ0a8DJfJ97XiyTlWFeTlRIyHv+N6QdhN3441o=;
        b=SxSwCON/fUSStjQVQUPoslzVyhCP8myJC6LEweeRIkeM228JxX9Lkv1HPTQDlv72dm
         IO64MtA3SLxhfnfBFA6tDSqO5xYPVKtEYFl2qU/vbzGB46TDcShWebccQDH710vVaxjH
         B96yRASLbsVtpJLXrF5DnMlKJvGPCb/deY/iZ81i6klgfw1+tm4UPEizegEeJo99Z7IF
         a/HzjP93/BSN3IsKbA/OaC5+nX9J+78pQVsTxnKxZvzMrRNhfb0/O5DETKh1Wt2cFPzl
         y1hJpHLkiQ4LTSpdAZ/bGk1/ja0N0RMA5JPByI19mi/wdA1U+j5px6LeQoZtKCrTnTr5
         fyCg==
X-Gm-Message-State: ACgBeo2yA3Z4cUoEDIDi8xZ5M90XLFIOc/kMoCVTQtbUW01ZkJrwk9Xg
        WBvBy0tMPt8Phi8G++9OWADqfjblUyfYNA==
X-Google-Smtp-Source: AA6agR7Lw7nWNGImLU0BhFP+GIzL9GozsGihMV/p6cayKqM1XM068fZxfk4HialfXEVnY25bkv487w==
X-Received: by 2002:a63:ef54:0:b0:41a:56e7:aeb3 with SMTP id c20-20020a63ef54000000b0041a56e7aeb3mr22482368pgk.49.1660136504867;
        Wed, 10 Aug 2022 06:01:44 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id b11-20020a170903228b00b0016edff78844sm12816509plh.277.2022.08.10.06.01.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Aug 2022 06:01:44 -0700 (PDT)
Message-ID: <8cbaeb6f-f85d-7d7b-5289-4fd0c64f1107@kernel.dk>
Date:   Wed, 10 Aug 2022 07:01:42 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [GIT PULL] GitHub bot update
Content-Language: en-US
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc:     Kanna Scarlet <knscarlet@gnuweeb.org>,
        Fernanda Ma'rouf <fernandafmr12@gnuweeb.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
References: <970548e2-e888-4d79-6eb2-789a6e75a872@gnuweeb.org>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <970548e2-e888-4d79-6eb2-789a6e75a872@gnuweeb.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/9/22 6:55 PM, Ammar Faizi wrote:
> Hi Jens,
> 
> Just a single commit to upgrade the OS on the GitHub bot CI.
> "ubuntu-latest" doesn't give the latest version of Ubuntu. Explicitly
> specify "ubuntu-22.04" to get the latest version. This is just like
> commit:
> 
>    f642f8fd71bf (".github: Upgrade GitHub bot to Ubuntu 22.04 and gcc-11")
> 
> ... but for the shellcheck.
> 
> Please pull!

Thanks, pulled.

-- 
Jens Axboe

