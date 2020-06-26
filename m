Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04F5820BB62
	for <lists+io-uring@lfdr.de>; Fri, 26 Jun 2020 23:24:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725828AbgFZVX7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 26 Jun 2020 17:23:59 -0400
Received: from mail2.protonmail.ch ([185.70.40.22]:42495 "EHLO
        mail2.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725803AbgFZVX7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 26 Jun 2020 17:23:59 -0400
Date:   Fri, 26 Jun 2020 21:23:56 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=remexre.xyz;
        s=protonmail; t=1593206637;
        bh=fXYFLbAxP79iO82XZtKQr7T53exh54Kym98It5n1eqw=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=rgbyAbeHPpWqtIZYw61h2TmD7DS4lnv174jWEQD9JJ1jHTSwHR7E6GsNhCzX+yrbS
         Lu/HxuToow0n770VMKYJfd3hWhhW96IayQG16zu1Al2E9GbTnCYGcVAc32cVVDOlYS
         ZVNPpTbBnRbK7Qg64D5ONdTPvmWl8Afebwo9Nn2g=
To:     Jann Horn <jannh@google.com>
From:   Nathan Ringo <nathan@remexre.xyz>
Cc:     "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
Reply-To: Nathan Ringo <nathan@remexre.xyz>
Subject: Re: sendto(), recvfrom()
Message-ID: <qi2VGb4ci91I92FmT1MuSqXiShoFDXfWQpkQx3Au1GW5cXfORnYxvSPN99UaLcTFGVQqG_3zt3rJVWknvkEnvhX-vnlF32O-wk69XgD5BcI=@remexre.xyz>
In-Reply-To: <CAG48ez2-FviP63K8bX+vTatb3RL5ZZ9q0nwrW11iTsknWTUy3Q@mail.gmail.com>
References: <bRmxY0zzqGcGWE4Xg-O3jlU42WtEEMUb4iGvfOvesLybmoDNJ242_9phm-DHLM8zJzu7C63iKCZq4ZJLcrYXnuVewHvCgiO21tW2CSuabnE=@remexre.xyz> <CAG48ez2-FviP63K8bX+vTatb3RL5ZZ9q0nwrW11iTsknWTUy3Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=1.3 required=7.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FROM_SUSPICIOUS_NTLD,
        PDS_OTHER_BAD_TLD shortcircuit=no autolearn=disabled version=3.4.4
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on mail.protonmail.ch
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Friday, June 26, 2020 4:08 PM, Jann Horn <jannh@google.com> wrote:
> What is the benefit compared to IORING_OP_RECVMSG and
> IORING_OP_SENDMSG, which already exist (and provide a superset of
> sendto/recvfrom)?

Ah, I didn't realize this was the case, whoops. I guess I'm showing off
my lack of familiarity with Unix; I remembered sendmsg as being specific
to Unix domain sockets. I'll just use that, then.

--
Nathan Ringo
