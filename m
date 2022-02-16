Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFA894B8629
	for <lists+io-uring@lfdr.de>; Wed, 16 Feb 2022 11:49:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229455AbiBPKtT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Feb 2022 05:49:19 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230281AbiBPKtM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Feb 2022 05:49:12 -0500
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B347EC
        for <io-uring@vger.kernel.org>; Wed, 16 Feb 2022 02:49:00 -0800 (PST)
Received: by mail-lf1-x142.google.com with SMTP id j7so3054370lfu.6
        for <io-uring@vger.kernel.org>; Wed, 16 Feb 2022 02:49:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:sender:from:date:message-id:subject:to;
        bh=y/WwzOufdV8bFjC2XhKxeIddPBCZMNKZVHLfMOMvj6I=;
        b=iQOOErdMyg0YJRTTgG4ji0zDDGM+SIytjJRPcEEQPuaTGwhp/aiigfZDD9bqY9/lle
         n3shoMbeqOoJnB4Gs7y3PxV1yWs+FgXg1DQni9fEkWnQvfD6ujF3JdwrCYtfXEiXwCFG
         EMoIqTGUg8PlfYD2Dudm7oF2e6PrsXBUa8abDFNcHtD9XZrYbwVgkIOdCPQkAfke1bW2
         d6oSo3gc7HEQUImg17cy7ua6fRdTLx0tbtHrFIX7T0BgySGsesGFAfqiIAkrXpdBt4pE
         asNwo+zZJpnL5PI+3yd8D981jYdO1vW3vX9FaNDq6Sca4WePJrDdIJgk92JNsvfW0zzi
         7/iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:sender:from:date
         :message-id:subject:to;
        bh=y/WwzOufdV8bFjC2XhKxeIddPBCZMNKZVHLfMOMvj6I=;
        b=INSCKqV04jcyCtEy1tXr2PhsqgjX3tktiBl8la0T36cX4khaJ956qnPIUEC2wuqVYD
         oNEvfugtcca6QDZK/ZCH6i1RkDt+ARGVb3+XUA9/VKi5A6dBPTFyy844agZJotksd0IA
         6CDFgMdFTdjbxjv26zrHahhuLhX0KrYPh8YzNSurZp524BXMqBvlcd9wz6rFiNilLcP0
         ckEWSwgUoEcQOgeQk+OIxnzVQbr3g4xhxQ1GReFrJ8ZRYDUrbAWpg5AzEcPw9LXcXmxU
         vUPJapkZUQWSmJJF57LEdD4+Tr8U5FLxVf2CnvsJ/ypoaGYfqW+nmiO1sDVr+zD36wi/
         aVIg==
X-Gm-Message-State: AOAM532BvlPyxuAN/IRNOZKh0ydHTiBYUwrzvng4MslU9EZoDzOj21wB
        d3yeoX4cPqUZqH1mkBuXLyRKWlk1iTpcpvwquAE=
X-Google-Smtp-Source: ABdhPJxwdwf5qoj45PaA+ECEBde3DhBE+xadDzz9D6HvJYXumOZlQvtgcirtNw7dEH8rx6RjtNALSddoy+kJlHSuQxQ=
X-Received: by 2002:a05:6512:318b:b0:443:946a:83a3 with SMTP id
 i11-20020a056512318b00b00443946a83a3mr1214361lfe.269.1645008538878; Wed, 16
 Feb 2022 02:48:58 -0800 (PST)
MIME-Version: 1.0
Reply-To: drtracywilliams89@gmail.com
Sender: modym1332015@gmail.com
Received: by 2002:a05:6520:4084:b0:190:abcf:a3ee with HTTP; Wed, 16 Feb 2022
 02:48:58 -0800 (PST)
From:   "Dr. Tracy Williams" <tracy0wiliams@gmail.com>
Date:   Wed, 16 Feb 2022 02:48:58 -0800
X-Google-Sender-Auth: l5OWyKyAhlsA2XBtonT5g6Hg7Ng
Message-ID: <CAKSnB2aw-FtUPGMx2iftVHpA_wrRKvuHZ2vHRUtr5Zf=oBHrpQ@mail.gmail.com>
Subject: From Dr. Tracy Williams.
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.6 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4750]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:142 listed in]
        [list.dnswl.org]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [drtracywilliams89[at]gmail.com]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [modym1332015[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [modym1332015[at]gmail.com]
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.5 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello Dear,

how are you today,I hope you are doing great. It is my great pleasure
to contact you,I want to make a new and special friend,I hope you
don't mind. My name is Tracy Williams

from the United States, Am a french and English nationality. I will
give you pictures and more details about my self as soon as i hear
from you in my email account bellow,
Here is my email address; drtracywilliams89@gmail.com


Please send your reply to my PRIVATE  mail box.
Thanks,

Tracy Williams.
