Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 634E357E3A1
	for <lists+io-uring@lfdr.de>; Fri, 22 Jul 2022 17:21:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233627AbiGVPVo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 22 Jul 2022 11:21:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235096AbiGVPVn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 22 Jul 2022 11:21:43 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E70CB93601
        for <io-uring@vger.kernel.org>; Fri, 22 Jul 2022 08:21:42 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id r70so3862000iod.10
        for <io-uring@vger.kernel.org>; Fri, 22 Jul 2022 08:21:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:in-reply-to:references:subject:message-id:date:mime-version
         :content-transfer-encoding;
        bh=oRqpYE3FVMvZb73yST+b1XLT7UUQD1kcizFDJP2UOjM=;
        b=h5q0FHGbB10x1HKb7GTXGuIrWIV55lF2+FNg3AydybP/OsrcBeZ3WY2w1Fty6ZCAQD
         k+2btFb2aiYY+O4EJpe/4E9XvdMsGvWlbO3ICo6RkEBqEAE7ONVJBJ2WQ1eQvrmJ+Z36
         dN6ok+M7W29MR65/cUtWKrje9k4s9qgPnP/tIkhuAInHLa8DaYXKN+KctGn6Q/iUqCVB
         MkTyPmFIEu8rlcyzX8xe+LWkb04Z/NWTzEobBmKSWKy8Eoa0pNuL73f3ceEKXZ3F0UP2
         oRrlahIGyRnGdQcPhGv2+6MvyIbWE2233jYfmYF0svefG1y7ZmVwOb2wI8f85y9xOZRI
         zd3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=oRqpYE3FVMvZb73yST+b1XLT7UUQD1kcizFDJP2UOjM=;
        b=TuRbkJ0ZUbGVx5Ssj9Zuyc+Vzd1MLorRojt6miHns0KHpMhIY2RnYz33WdJPbQcFYo
         Li+Ja8T2+d1elbdLifn1U0aEsjts+2I7K9jhzc1FkFxjQ/Ta+36DiHqf1EYYWzAjII9j
         3C9BvSFt8WU3ecWD3Zi4iu2RQmxJxqLS4ObBx62jgagnjcRe2sfJ4eP/NTCcZMsdRQ/y
         aHWVVYO0SKTXLV8iPSlB0VJTKT98MJT/L0IFIHXbs/WXeb3oYA+7gsB00BsJsbx8AAlS
         txMzwP5aAf+rsLwQiwxiFRnmsD8TWLPQ3kTyzyOWqfAxJBJkx1qeyedIhwbPeNK6aQqY
         3alw==
X-Gm-Message-State: AJIora81uwK5vWKFNQniEzH1Qsl7qwHQjG83o+xUxWhYKgvtnPMiUjgX
        OUUTv6it5T16VumsqEME3QwybeK5+gjZBg==
X-Google-Smtp-Source: AGRyM1s94P6gZ2W2EGOC9Nq4rg3E6k8gMaYwd73BwD5R+541hWU5xNw4DmHnmBWN+lF1au5qUXuh7A==
X-Received: by 2002:a05:6638:24c9:b0:341:4916:df8f with SMTP id y9-20020a05663824c900b003414916df8fmr277107jat.196.1658503302050;
        Fri, 22 Jul 2022 08:21:42 -0700 (PDT)
Received: from [127.0.1.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id l1-20020a056e020e4100b002db4e72ead5sm1869155ilk.50.2022.07.22.08.21.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jul 2022 08:21:41 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, asml.silence@gmail.com
In-Reply-To: <9e282a50456df4451e28189bd3ac6e54d598ecc3.1658490521.git.asml.silence@gmail.com>
References: <9e282a50456df4451e28189bd3ac6e54d598ecc3.1658490521.git.asml.silence@gmail.com>
Subject: Re: [PATCH liburing 1/1] man/io_uring_setup.2: document IORING_SETUP_SINGLE_ISSUER
Message-Id: <165850330140.235950.18246034144313945687.b4-ty@kernel.dk>
Date:   Fri, 22 Jul 2022 09:21:41 -0600
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

On Fri, 22 Jul 2022 12:49:02 +0100, Pavel Begunkov wrote:
> 


Applied, thanks!

[1/1] man/io_uring_setup.2: document IORING_SETUP_SINGLE_ISSUER
      commit: 02adcf497c9f4ca20175b291f8269faff4da958c

Best regards,
-- 
Jens Axboe


