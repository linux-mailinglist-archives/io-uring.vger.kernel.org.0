Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3C28552E8B
	for <lists+io-uring@lfdr.de>; Tue, 21 Jun 2022 11:37:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348999AbiFUJhi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 21 Jun 2022 05:37:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242198AbiFUJhi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 21 Jun 2022 05:37:38 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8990C275D0
        for <io-uring@vger.kernel.org>; Tue, 21 Jun 2022 02:37:37 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id l11so23454399ybu.13
        for <io-uring@vger.kernel.org>; Tue, 21 Jun 2022 02:37:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=/0bRExIb6Mv4sy5raFRmeQINC+UUx7zEZcUUOWWOPJg=;
        b=cYTFPAUCRTmBkCR+cVA5ZNzjA2Uqgc/HjR0zlOgbg9VuBnX3dwzG4Kj4FjhnRnvcvi
         wTyu7niNLf4R1OK+/LKzjCUdZ6XYPAkUSTnlVnVi+LNWF7h/kdKvp9e/2HfkHETOu+VA
         2PSxObV5wY/xFH3voyR2x2qFYgLNClifj7+m1vJSVh24kwl8FGKk16kvXtvOc5VNOcrH
         UyKoKG1yWb9wGAVlxzIf2tj/E95L7Uf8qdMRFG5eH2sJkEk6Ptgi4txcgY8ONngKnpoS
         ooFz1cPReMEGpVh7DyEHUxeOUISoI1NpJTxEGX0hj235wu00/Nw5bO0+JQPRTCdmby+0
         /3DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=/0bRExIb6Mv4sy5raFRmeQINC+UUx7zEZcUUOWWOPJg=;
        b=7fUolvU/Kez2qbvBYbqQszGcToolV5y8onNiCjExCfG6Zgv8mNYwNpNWRtk9kajwSU
         zv2HQkiPeIIE9bwBRaQMXojgN1lfJpw4CbNEJt8VwXOfu/Ls7slYNldhfbFQP7z5YTS2
         qb5kHwXJd4sYLowxmt62bsUOa+auRAz+1/1GqwUwm67tgCaT04d85C8Hnc1MpYCoNOc/
         AczPyTIlXuO4568jtBbNspZAZ05CyPw1VOcXTQM5+oTEKbohf9qj7EG2YbPgmOmm4GRQ
         yeyGrAw5NO5/A5cSRmlNfThLxaczR/wexU/PfhT4BUOLFjiJefjmXCe7ixU7R0O4voKA
         d3+A==
X-Gm-Message-State: AJIora/ntzXIDEV/MRiIsRGJfgMjNjl8Wj4wcVL5a52YGiSV5/WG1u7G
        1cvSrx9RAjKjWbsT5/yEVai+44JFI3JuieFm2wU=
X-Google-Smtp-Source: AGRyM1s/+WOFM12bU7OZIdCkvOR7pxg4SYt+lPISunN/vKsxgA44GhPMdCRChVbTCxEcM9644YCRjMJp9MGT8NprzSY=
X-Received: by 2002:a25:a066:0:b0:664:411a:1071 with SMTP id
 x93-20020a25a066000000b00664411a1071mr30958144ybh.366.1655804256510; Tue, 21
 Jun 2022 02:37:36 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:7010:e10a:b0:2d9:e631:94d0 with HTTP; Tue, 21 Jun 2022
 02:37:36 -0700 (PDT)
Reply-To: dimitryedik@gmail.com
From:   Dimitry Edik <lsbthdwrds@gmail.com>
Date:   Tue, 21 Jun 2022 02:37:36 -0700
Message-ID: <CAGrL05YAoCppH57zvOR2tcLWnZjxqWCDCU1_Az8pwHME1GWH0w@mail.gmail.com>
Subject: Dear Partner,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=7.8 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        LOTS_OF_MONEY,MONEY_FREEMAIL_REPTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_MONEY_PERCENT,T_SCC_BODY_TEXT_LINE,UNDISC_FREEM,
        UNDISC_MONEY autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:b29 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [lsbthdwrds[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  2.2 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
        *  2.0 MONEY_FREEMAIL_REPTO Lots of money from someone using free
        *      email?
        *  0.0 T_MONEY_PERCENT X% of a lot of money for you
        *  2.0 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello Dear,

My Name is Dimitry Edik from Russia A special assistance to my Russia
boss who deals in oil import and export He was killed by the Ukraine
soldiers at the border side. He supplied
oil to the Philippines company and he was paid over 90 per cent of the
transaction and the remaining $18.6 Million dollars have been paid into a
Taiwan bank in the Philippines..i want a partner that will assist me
with the claims. Is a (DEAL ) 40% for you and 60% for me
I have all information for the claims.
Kindly read and reply to me back is 100 per cent risk-free

Yours Sincerely
Dimitry Edik
